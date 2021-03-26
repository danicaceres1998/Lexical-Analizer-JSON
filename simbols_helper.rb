### Structures ###
Token = Struct.new(:id, :lexeme, :lexical_component, :regular_expresion, :data_type)

### Table Module ###
module SimbolsHelper
  L_SQUARE_BRACKET  =  Token.new(1, '[', 'L_CORCHETE', /\[/, nil)
  R_SQUARE_BRACKET  =  Token.new(2, ']', 'R_CORCHETE', /\]/, nil)
  L_CURLY_BRACE     =  Token.new(3, '{', 'L_LLAVE', /\{/, nil)
  R_CURLY_BRACE     =  Token.new(4, '}', 'R_LLAVE', /\}/, nil)
  COMA              =  Token.new(5, ',', 'COMA', /,/, nil)
  TWO_POINTS        =  Token.new(6, ':', 'DOS_PUNTOS', /:/, nil)
  PR_TRUE           =  Token.new(7, 'true', 'PR_TRUE', /true|TRUE/, nil)
  PR_FALSE          =  Token.new(8, 'false', 'PR_FALSE', /false|FALSE/, nil)
  PR_NULL           =  Token.new(9, 'null', 'PR_NULL', /null|NULL/, nil)
  LITERAL_STRING    =  Token.new(10, nil, 'LITERAL_CADENA', /".*"/, nil)
  LITERAL_NUMBER    =  Token.new(11, nil, 'LITERAL_NUM', /[-+]?[0-9]+(\.[0-9]+)?+([eE][-+]?[0-9]+)?/, nil)
  SPACE             =  ' '.freeze
  LINE_BREAK        =  "\n".freeze
  TABULATOR         =  "\t".freeze

  def initialize(*args)
    super(*args)
    @tokens_table = []
  end
end