#!/usr/bin/env ruby
require_relative 'simbols_helper'

class Lexer
  include SimbolsHelper
  DEFAULT_OUTPUT_NAME = 'output.txt'.freeze
  CURRENT_PATH = File.expand_path(File.dirname(__FILE__))

  def initialize
    super
    @file = nil
    @current_char = nil
    @tokens_file = []
    @line_number = 1
    @index = 0
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
    @tokens_file = @file.read.each_char.reduce([]) { |acc, el| acc << el }
    @file.close
    get_token
    build_output
  end

  def get_token
    loop do
      @current_char = @tokens_file[@index]
      break if @current_char.nil?
      if @current_char == SPACE or @current_char == LINE_BREAK or @current_char == TABULATOR
        @tokens_table << @current_char # Se agrego para poder identar de igual manera que el fuente.json
        @line_number += 1 if @current_char == LINE_BREAK
      elsif !!@current_char.match(L_SQUARE_BRACKET.regular_expresion)
        add_lexical_component(L_SQUARE_BRACKET.lexical_component)
      elsif !!@current_char.match(R_SQUARE_BRACKET.regular_expresion)
        add_lexical_component(R_SQUARE_BRACKET.lexical_component)
      elsif !!@current_char.match(L_CURLY_BRACE.regular_expresion)
        add_lexical_component(L_CURLY_BRACE.lexical_component)
      elsif !!@current_char.match(R_CURLY_BRACE.regular_expresion)
        add_lexical_component(R_CURLY_BRACE.lexical_component)
      elsif !!@current_char.match(COMA.regular_expresion)
        add_lexical_component(COMA.lexical_component)
      elsif !!@current_char.match(TWO_POINTS.regular_expresion)
        add_lexical_component(TWO_POINTS.lexical_component)
      end
      break if @index == @tokens_file.count
      @index += 1
    end
  end

  def add_lexical_component(component)
    @tokens_table << "#{component} "
  end

  def build_output
    new_file = File.open(DEFAULT_OUTPUT_NAME, 'w')
    @tokens_table.each do |token|
      print(token)
      new_file.write(token)
    end
    puts "\n[INFO]: El resultado se encuentra en -> #{CURRENT_PATH + "/#{DEFAULT_OUTPUT_NAME}"}"
    puts "[INFO]: Total de lineas = #{@line_number}"
    puts "[INFO]: Total de tokens = #{@tokens_table.count}"
  end
end

### MAIN ###
Lexer.new.main
