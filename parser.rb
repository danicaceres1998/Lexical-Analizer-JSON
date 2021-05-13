require_relative 'anlexer'

class Parser
  include SimbolsHelper

  def initialize
    super
    @file = nil
    @lexer = Lexer.new
    @tokens = nil
    @current_token = nil
    @line_number = 0
    @index = 0
    @str_to_evaluate = ''
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
      init_parser
    end
  end

  private

  def init_parser
    @tokens = @lexer.get_tokens(@file)
    @current_token = @tokens.first
    json
    puts @errors
  end

  def json
    element
  end

  def element
    byebug
    case @current_token
    when L_CURLY_BRACE.lexeme
      object
    when L_SQUARE_BRACKET.lexeme
      array
    else
      add_error
    end
  end

  def object
    byebug
    match(@current_token, L_CURLY_BRACE)
    clean_object
    match(@current_token, R_CURLY_BRACE)
  end

  def clean_object
    byebug
    attributes_list unless @current_token.match? R_CURLY_BRACE.regular_expresion
  end

  def attributes_list
    byebug
    attribute_name
    match(@current_token, TWO_POINTS)
    attribute_value
  end

  def attribute_name
    byebug
    match(@current_token, LITERAL_STRING)
  end

  def attribute_value
    byebug
    if @current_token.match? LITERAL_STRING.regular_expresion
      match(@current_token, LITERAL_STRING)
      return
    elsif @current_token.match? LITERAL_NUMBER.regular_expresion
      match(@current_token, LITERAL_NUMBER)
      return
    elsif @current_token.match? PR_TRUE.regular_expresion
      match(@current_token, PR_TRUE)
      return
    elsif @current_token.match? PR_FALSE.regular_expresion
      match(@current_token, PR_FALSE)
      return
    elsif @current_token.match? PR_NULL.regular_expresion
      match(@current_token, PR_NULL)
      return
    else
      element
      return
    end
    add_error
  end

  def array
    byebug
    match(@current_token, L_SQUARE_BRACKET)
    clean_array
    match(@current_token, R_SQUARE_BRACKET)
  end

  def clean_array
    byebug
    element_list unless @current_token.match? R_SQUARE_BRACKET.regular_expresion
  end

  def element_list
    byebug
    element
    clean_list
  end

  def clean_list
    byebug
    if @current_token.match? COMA.regular_expresion
      match(@current_token, COMA)
      element_list
    end
  end

  def match(token, token_type)
    byebug
    if token.match? token_type.regular_expresion
      next_token
    else
      add_error
    end
  end

  def add_error
    byebug
    @errors << "#{@current_token}: #{@index}"
    next_token
  end

  def next_token
    @index += 1
    @current_token = @tokens[@index]
  end
end

### MAIN ###
if __FILE__ == $0
  Parser.new.main
end
