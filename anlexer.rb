#!/usr/bin/env ruby
require_relative 'simbols_helper'

class Lexer
  include SimbolsHelper
  DEFAULT_OUTPUT_FILE_NAME = 'output.txt'.freeze
  CURRENT_PATH = File.expand_path(File.dirname(__FILE__))
  NC = "\e[0m".freeze # No color
  RED = "\e[0;31m".freeze # Red color

  def initialize
    super
    @file = nil
    @current_char = nil
    @chars_file = []
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
      rescue Errno::ENOENT => e
        puts "[ERROR]: El archivo #{ARGV.first} no existe !"
        exit 1
      end
      init_lexer
    end
  end

  private

  def init_lexer
    @chars_file = @file.read.each_char.reduce([]) { |acc, el| acc << el }
    @file.close
    @line_number += 1 unless @chars_file.empty?
    get_token
    build_output
  end

  def get_token
    loop do
      @current_char = @chars_file[@index]
      break if @current_char.nil?
      if @current_char == SPACE or @current_char == LINE_BREAK or @current_char == TABULATOR
        # Se agregaron para poder identar de igual manera que el fuente.json
        add_lexical_component(@current_char)
        @line_number += 1 if @current_char == LINE_BREAK
      elsif @current_char.match? L_SQUARE_BRACKET.regular_expresion
        token_matched(L_SQUARE_BRACKET.lexeme, L_SQUARE_BRACKET)
      elsif @current_char.match? R_SQUARE_BRACKET.regular_expresion
        token_matched(R_SQUARE_BRACKET.lexeme, R_SQUARE_BRACKET)
      elsif @current_char.match? L_CURLY_BRACE.regular_expresion
        token_matched(L_CURLY_BRACE.lexeme, L_CURLY_BRACE)
      elsif @current_char.match? R_CURLY_BRACE.regular_expresion
        token_matched(R_CURLY_BRACE.lexeme, R_CURLY_BRACE)
      elsif @current_char.match? COMA.regular_expresion
        token_matched(COMA.lexeme, COMA)
      elsif @current_char.match? TWO_POINTS.regular_expresion
        token_matched(TWO_POINTS.lexeme, TWO_POINTS)
      elsif @current_char.match? REGEX_ALPHANUM
        rebuild_str_to_evaluate
        loop do
          @index += 1
          @current_char = @chars_file[@index]
          if not @current_char.match? REGEX_ALPHANUM or @current_char.nil?
            @index -= 1
            break
          end
          @str_to_evaluate += @current_char
        end
        validate_token(@str_to_evaluate, [PR_TRUE, PR_FALSE, PR_NULL])
      elsif @current_char == DOUBLE_QUOTES
        rebuild_str_to_evaluate
        loop do
          @index += 1
          @current_char = @chars_file[@index]
          @str_to_evaluate += @current_char
          break if @current_char == DOUBLE_QUOTES or @current_char.nil?
        end
        validate_token(@str_to_evaluate, [LITERAL_STRING])
      elsif @current_char.match? REGEX_NUMERIC
        rebuild_str_to_evaluate
        loop do
          @index += 1
          @current_char = @chars_file[@index]
          if not @current_char.match? REGEX_NUMERIC or @current_char.nil?
            @index -= 1
            break
          end
          @str_to_evaluate += @current_char
        end
        validate_token(@str_to_evaluate, [LITERAL_NUMBER])
      else
        add_lexical_error(@current_char)
      end
      break if @index == @chars_file.count
      @index += 1
    end
  end

  def token_matched(lexeme, token_type)
    add_token(lexeme, token_type)
    add_lexical_component("#{token_type.lexical_component} ")
  end

  def add_lexical_error(lexeme)
    @errors << @line_number
    lexeme = (lexeme.nil? or lexeme.empty?) ? 'UndefinedSimbol' : lexeme
    add_lexical_component("LEXICAL_ERROR='#{lexeme}' ")
  end

  def rebuild_str_to_evaluate
    @str_to_evaluate.clear
    @str_to_evaluate += @current_char
  end

  def validate_token(lexeme, token_types)
    token_types.each do |token_type|
      if lexeme.match? token_type.regular_expresion
        token_matched(@str_to_evaluate, token_type)
        @str_to_evaluate.clear
        return
      end
    end
    add_lexical_error(lexeme)
  end

  def build_output
    new_file = File.open(DEFAULT_OUTPUT_FILE_NAME, 'w')
    @lexical_comp_list.each do |token|
      print(token.include?('ERROR') ? "#{RED}#{token}#{NC}" : token)
      new_file.write(token)
    end
    puts "\n[INFO]: El resultado se encuentra en -> #{CURRENT_PATH + "/#{DEFAULT_OUTPUT_FILE_NAME}"}"
    puts "[INFO]: Total de lineas = #{@line_number}"
    @lexical_comp_list.select! { |token| token != LINE_BREAK && token != TABULATOR && token != SPACE }
    puts "[INFO]: Total de tokens = #{@lexical_comp_list.count}"
    puts "[INFO]: Tokens list: [#{@simbols_table.keys.reduce([]) { |acc, el| acc << "\"#{RED}#{el}#{NC}\"" }.join(', ')}]"
    unless @errors.empty?
      @errors = @errors.uniq
      puts "[ERROR]: Ocurrieron errores en las sgtes lineas: [#{@errors.join(', ')}]"
    end
  end
end

### MAIN ###
Lexer.new.main
