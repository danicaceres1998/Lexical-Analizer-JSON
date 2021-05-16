require_relative 'parser'
require 'pry'

class Translator
  include SimbolsHelper
  DEFAULT_OUTPUT_FILE = 'output.xml'.freeze
  CURRENT_PATH = File.expand_path(File.dirname(__FILE__))
  INIT = 0
  TAB = 2

  def initialize
    super
    @file = nil
    @output_file = nil
    @parser = Parser.new
    @tab_position = 0
    @tokens = nil
    @current_token = nil
    @index = 0
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
      init_translation
    end
  end

  def parse_file(file)
    @file = file
    init_parser(false)
  end

  private

  def init_translation
    @tokens = @parser.parse_file(@file)
    @current_token = @tokens.first
    @output_file = File.open(DEFAULT_OUTPUT_FILE, 'w')
    json
    build_output
  rescue StandardError => e
    puts e.message
  end

  def json
    element
  end

  def element
    case @current_token
    when L_CURLY_BRACE.regular_expresion
      object
    when L_SQUARE_BRACKET.regular_expresion
      array
    end
  end

  def object
    match(L_CURLY_BRACE)
    clean_object
    match(R_CURLY_BRACE)
  end

  def clean_object
    attributes_list unless @current_token.match? R_CURLY_BRACE.regular_expresion
    @tab_position -= TAB
  end

  def attributes_list
    attribute
    put_break_line
    clean_attribute_list
  end

  def clean_attribute_list
    if @current_token.match? COMA.regular_expresion
      match(COMA)
      attributes_list
    end
  end

  def attribute
    put_tab
    write_file('<')
    att = @current_token.gsub(/"/, '')
    write_file(att)
    attribute_name
    write_file('>')
    match(TWO_POINTS)
    attribute_value
    write_file('</')
    write_file(att)
    write_file('>')
  end

  def attribute_name
    match(LITERAL_STRING)
  end

  def attribute_value
    case @current_token
    when L_SQUARE_BRACKET.regular_expresion
      put_break_line
      @tab_position += TAB
      element
      put_tab
    when L_CURLY_BRACE.regular_expresion
      put_break_line
      @tab_position += TAB
      element
      put_tab
    when LITERAL_STRING.regular_expresion
      write_file(@current_token)
      match(LITERAL_STRING)
    when LITERAL_NUMBER.regular_expresion
      write_file(@current_token)
      match(LITERAL_NUMBER)
    when PR_TRUE.regular_expresion
      write_file(@current_token)
      match(PR_TRUE)
    when PR_FALSE.regular_expresion
      write_file(@current_token)
      match(PR_FALSE)
    when PR_NULL.regular_expresion
      write_file(@current_token)
      match(PR_NULL)
    end
  end

  def array
    match(L_SQUARE_BRACKET)
    clean_array
    match(R_SQUARE_BRACKET)
    @tab_position -= TAB
  end

  def clean_array
    element_list unless @current_token.match? R_SQUARE_BRACKET.regular_expresion
  end

  def element_list
    put_tab
    write_file("<item>\n")
    @tab_position += TAB
    element
    put_tab
    write_file("</item>\n")
    clean_list
  end

  def clean_list
    if @current_token.match? COMA.regular_expresion
      match(COMA)
      element_list
    end
  end

  def match(token_type)
    return if @current_token.nil?

    next_token if @current_token.match? token_type.regular_expresion
  end

  def next_token
    @index += 1
    @current_token = @tokens[@index]
  end

  def build_output
    puts "\n[INFO]: El resultado se encuentra en -> #{CURRENT_PATH + "/#{DEFAULT_OUTPUT_FILE}"}"
  end

  def write_file(str)
    @output_file.write(str)
  end

  def put_tab
    @output_file.write(@tab_position.times.reduce('') { |acc, _| acc += ' ' })
  end

  def put_break_line
    @output_file.write(LINE_BREAK) if @index != INIT
  end
end

### MAIN ###
if __FILE__ == $0
  Translator.new.main
end
