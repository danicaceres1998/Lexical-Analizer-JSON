require_relative 'anlexer'

class Parser
  include SimbolsHelper
  PARSER_ERROR = '[ERROR]: Ocurrieron errores de compilacion'.freeze
  PARSER_INFO = '[INFO]: No ocurrio ningun error de compilacion'.freeze

  def initialize
    super
    @file = nil
    @lexer = Lexer.new
    @tokens = nil
    @line_numbers = nil
    @current_token = nil
    @index = 0
    @errors = []
  end

  def main
    if ARGV.first.nil?
      puts '[ERROR]: Debe de pasar como parametro el path al archivo fuente !'
      exit 1
    else
      begin
        @file = File.open(ARGV.first)
      rescue Errno::ENOENT
        puts "[ERROR]: El archivo #{ARGV.first} no existe !"
        exit 1
      end
      init_parser(true)
    end
  end

  def parse_file(file)
    @file = file
    init_parser(false)
    @tokens
  end

  private

  def init_parser(parser_mode)
    lexer_tokens = @lexer.get_tokens(@file)
    @tokens = lexer_tokens[:tokens]
    @line_numbers = lexer_tokens[:line_number]
    @current_token = @tokens.first
    json unless @tokens.empty?
    if parser_mode
      puts @errors.empty? ? PARSER_INFO : PARSER_ERROR
    else
      raise StandardError, PARSER_ERROR unless @errors.empty?
    end
  rescue StandardError => e
    puts e.message
    raise e unless parser_mode
  end

  def json
    check_input(FIRST_GROUP[:json], NEXT_GROUP[:json])
    unless search_in_group(NEXT_GROUP[:json])
      element
      check_input(NEXT_GROUP[:json], FIRST_GROUP[:json])
    end
  end

  def element
    check_input(FIRST_GROUP[:element], NEXT_GROUP[:element])
    unless search_in_group(NEXT_GROUP[:element])
      case @current_token
      when L_CURLY_BRACE.regular_expresion
        object
      when L_SQUARE_BRACKET.regular_expresion
        array
      else
        print_error
      end
      check_input(NEXT_GROUP[:element], FIRST_GROUP[:element], optional=true)
    end
  end

  def object
    check_input(FIRST_GROUP[:object], NEXT_GROUP[:object])
    unless search_in_group(NEXT_GROUP[:object])
      match(L_CURLY_BRACE)
      clean_object
      match(R_CURLY_BRACE)
      check_input(NEXT_GROUP[:object], FIRST_GROUP[:object], optional=true)
    end
  end

  def clean_object
    unless search_in_group(NEXT_GROUP[:clean_object])
      check_input(FIRST_GROUP[:clean_object], NEXT_GROUP[:clean_object])
      attributes_list
      check_input(NEXT_GROUP[:clean_object], FIRST_GROUP[:clean_object])
    end
  end

  def attributes_list
    check_input(FIRST_GROUP[:attributes_list], NEXT_GROUP[:attributes_list])
    unless search_in_group(NEXT_GROUP[:attributes_list])
      attribute
      clean_attribute_list
      check_input(NEXT_GROUP[:attributes_list], FIRST_GROUP[:attributes_list])
    end
  end

  def clean_attribute_list
    unless search_in_group(NEXT_GROUP[:clean_attributes_list])
      check_input(FIRST_GROUP[:clean_attributes_list], NEXT_GROUP[:clean_attributes_list], optional=true)
      if @current_token.match? COMA.regular_expresion
        match(COMA)
        attributes_list
      end
      check_input(NEXT_GROUP[:clean_attributes_list], FIRST_GROUP[:clean_attributes_list])
    end
  end

  def attribute
    check_input(FIRST_GROUP[:attribute], NEXT_GROUP[:attribute])
    unless search_in_group(NEXT_GROUP[:attribute])
      attribute_name
      match(TWO_POINTS)
      attribute_value
      check_input(NEXT_GROUP[:attribute], FIRST_GROUP[:attribute], optional=true)
    end
  end

  def attribute_name
    check_input(FIRST_GROUP[:attribute_name], NEXT_GROUP[:attribute_name])
    unless search_in_group(NEXT_GROUP[:attribute_name])
      match(LITERAL_STRING)
      check_input(NEXT_GROUP[:attribute_name], FIRST_GROUP[:attribute_name])
    end
  end

  def attribute_value
    check_input(FIRST_GROUP[:attribute_value], NEXT_GROUP[:attribute_value])
    unless search_in_group(NEXT_GROUP[:attribute_value])
      case @current_token
      when L_SQUARE_BRACKET.regular_expresion
        element
      when L_CURLY_BRACE.regular_expresion
        element
      when LITERAL_STRING.regular_expresion
        match(LITERAL_STRING)
      when LITERAL_NUMBER.regular_expresion
        match(LITERAL_NUMBER)
      when PR_TRUE.regular_expresion
        match(PR_TRUE)
      when PR_FALSE.regular_expresion
        match(PR_FALSE)
      when PR_NULL.regular_expresion
        match(PR_NULL)
      else
        print_error
      end
      check_input(NEXT_GROUP[:attribute_value], FIRST_GROUP[:attribute_value], optional=true)
    end
  end

  def array
    check_input(FIRST_GROUP[:array], NEXT_GROUP[:array])
    unless search_in_group(NEXT_GROUP[:array])
      match(L_SQUARE_BRACKET)
      clean_array
      match(R_SQUARE_BRACKET)
      check_input(NEXT_GROUP[:array], FIRST_GROUP[:array], optional=true)
    end
  end

  def clean_array
    unless search_in_group(NEXT_GROUP[:clean_array])
      check_input(FIRST_GROUP[:clean_array], NEXT_GROUP[:clean_array], optional=true)
      element_list
      check_input(NEXT_GROUP[:clean_array], FIRST_GROUP[:clean_array])
    end
  end

  def element_list
    check_input(FIRST_GROUP[:element_list], NEXT_GROUP[:element_list])
    unless search_in_group(NEXT_GROUP[:element_list])
      element
      clean_list
      check_input(NEXT_GROUP[:element_list], FIRST_GROUP[:element_list])
    end
  end

  def clean_list
    unless search_in_group(NEXT_GROUP[:clean_list])
      check_input(FIRST_GROUP[:clean_list], NEXT_GROUP[:clean_list], optional=true)
      if @current_token.match? COMA.regular_expresion
        match(COMA)
        element_list
      end
      check_input(NEXT_GROUP[:clean_list], FIRST_GROUP[:clean_list])
    end
  end

  def match(token_type)
    return if @current_token.nil?

    if @current_token.match? token_type.regular_expresion
      next_token
    else
      print_error
    end
  end

  def next_token
    @index += 1
    @current_token = @tokens[@index]
  end

  def check_input(firsts, follows, optional=false)
    return if search_in_group(firsts) or optional

    print_error
    scan_to(firsts + follows)
  end

  def scan_to(synchset)
    status = false
    loop do
      synchset.each do |token|
        if @current_token.nil? and token.regular_expresion.nil?
          status = true
          break
        elsif @current_token.nil?
          status = true
          break
        elsif token.regular_expresion.nil?
          if @current_token == token.lexeme
            status = true
            break
          end
        else
          if @current_token.match? token.regular_expresion 
            status = true
            break
          end
        end
      end
      break if status
      next_token
    end
  end

  def print_error
    @errors << "#{@current_token}: #{@line_numbers[@index]}"
    puts "Ocurrio un error en la linea: #{@line_numbers[@index]}, no se esperaba el token '#{@current_token}'"
  end

  def search_in_group(group)
    group.each do |f_t|
      if @current_token.nil? and f_t.regular_expresion.nil?
        return true
      elsif @current_token.nil?
        return true
      elsif f_t.regular_expresion.nil?
        return true if @current_token == f_t.lexeme
      else
        return true if @current_token.match? f_t.regular_expresion
      end
    end
    false
  end
end

### MAIN ###
if __FILE__ == $0
  Parser.new.main
end
