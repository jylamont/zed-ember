; Manually copied from upstream: https://github.com/zed-industries/zed/tree/6cac0b33dcd9b6af04f9d8dd21c8fa00937af97c/crates/languages/src/javascript
; Variables

(identifier) @variable

; Properties

(property_identifier) @property
(shorthand_property_identifier) @property
(shorthand_property_identifier_pattern) @property

; Function and method calls

(call_expression
  function: (identifier) @function)

(call_expression
  function: (member_expression
    property: (property_identifier) @function.method))

; Function and method definitions

(function_expression
  name: (identifier) @function)
(function_declaration
  name: (identifier) @function)
(method_definition
  name: (property_identifier) @function.method)
(method_definition
    name: (property_identifier) @constructor
    (#eq? @constructor "constructor"))

(pair
  key: (property_identifier) @function.method
  value: [(function_expression) (arrow_function)])

(assignment_expression
  left: (member_expression
    property: (property_identifier) @function.method)
  right: [(function_expression) (arrow_function)])

(variable_declarator
  name: (identifier) @function
  value: [(function_expression) (arrow_function)])

(assignment_expression
  left: (identifier) @function
  right: [(function_expression) (arrow_function)])

; Special identifiers

; ((identifier) @type
; (#match? @type "^[A-Z]"))
;(type_identifier) @type
;(predefined_type) @type.builtin

([
  (identifier)
  (shorthand_property_identifier)
  (shorthand_property_identifier_pattern)
 ] @constant
 (#match? @constant "^_*[A-Z_][A-Z\\d_]*$"))

; Literals

(this) @variable.special
(super) @variable.special

[
  (null)
  (undefined)
] @constant.builtin

[
  (true)
  (false)
] @boolean

(comment) @comment

[
  (string)
  (template_string)
] @string

(escape_sequence) @string.escape

(regex) @string.regex
(regex_flags) @keyword.regex
(number) @number

; Tokens

[
  ";"
;  "?."
  "."
  ","
  ":"
] @punctuation.delimiter

[
  "-"
  "--"
  "-="
  "+"
  "++"
  "+="
  "*"
  "*="
  "**"
  "**="
  "/"
  "/="
  "%"
  "%="
  "<"
  "<="
  "<<"
  "<<="
  "="
  "=="
  "==="
  "!"
  "!="
  "!=="
  "=>"
  ">"
  ">="
  ">>"
  ">>="
  ">>>"
  ">>>="
  "~"
  "^"
  "&"
  "|"
  "^="
  "&="
  "|="
  "&&"
  "||"
  "??"
  "&&="
  "||="
  "??="
] @operator

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
]  @punctuation.bracket

(ternary_expression
  [
    "?"
    ":"
  ] @operator
)

[
  "as"
  "async"
  "await"
  "break"
  "case"
  "catch"
  "class"
  "const"
  "continue"
  "debugger"
  "default"
  "delete"
  "do"
  "else"
  "export"
  "extends"
  "finally"
  "for"
  "from"
  "function"
  "get"
  "if"
  "import"
  "in"
  "instanceof"
  "let"
  "new"
  "of"
  "return"
  "set"
  "static"
  "switch"
  "target"
  "throw"
  "try"
  "typeof"
;  "using"
  "var"
  "void"
  "while"
  "with"
  "yield"
] @keyword

(template_substitution
  "${" @punctuation.special
  "}" @punctuation.special) @embedded

;(type_arguments
;  "<" @punctuation.bracket
;  ">" @punctuation.bracket)

(decorator "@" @punctuation.special)

; Keywords

[
;  "abstract"
;  "declare"
;  "enum"
  "export"
;  "implements"
;  "interface"
;  "keyof"
;  "namespace"
;  "private"
;  "protected"
;  "public"
;  "type"
;  "readonly"
;  "override"
] @keyword

(glimmer_opening_tag) @tag
(glimmer_closing_tag) @tag

(glimmer_template) ["<" "</" ">"] @punctuation.bracket
