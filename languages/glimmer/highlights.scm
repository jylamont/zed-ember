
; === Tag Names ===

; Tags that start with a lower case letter are HTML tags
; We'll also use this highlighting for named blocks (which start with `:`)
((tag_name) @tag
  (#match? @tag "^(:)?[a-z]"))
; Tags that start with a capital letter are Glimmer components
((tag_name) @constructor
  (#match? @constructor "^[A-Z]"))

(attribute_name) @attribute
(string_literal) @string
(number_literal) @number
(boolean_literal) @boolean
(concat_statement) @string
(comment_statement) @comment

; === Block Statements ===

(hash_pair
  key: (identifier) @property)

; Start by making all identifiers as variabes
(identifier) @variable

; Mark all paths e.g. (something.else) as properties
(path_expression
  (identifier) @property)

; Mark first path identifier as a variable e.g. ([something].else)
(path_expression
  (identifier)+ @variable)

; Overrides all identifiers named `this`
((identifier) @variable.special
  (#eq? @variable.special "this"))

; Helpers are functions
(helper_invocation
  helper: [
    (path_expression (identifier) @function)
    (identifier) @function
  ]
)

((identifier) @keyword
  (#any-of? @keyword
    "yield"
    "outlet"
    "debugger"))

[
  "<"
  ">"
  "</"
  "/>"
  "{{"
  "}}"
  "~}}"
  "{{/"
  "{{#"
  "{{~#"
  "{{~"
  "{{~/"
  ")"
  "("
] @punctuation.bracket

"." @punctuation.delimiter
"as" @keyword

[
  "="
  "|"
] @operator

; classic component invocation
(block_statement_start
  path: (identifier) @constructor)
(block_statement_end
  path: (identifier) @constructor)

; Override for built-in keywords
(
  [
    (block_statement_start path: (identifier) @keyword)
    (block_statement_end path: (identifier) @keyword)
  ]
  (#any-of? @keyword
    "each"
    "each-in"
    "unless"
    "with"
    "in-element"
    "let"
    "if"
  )
)

(mustache_statement
	(identifier) @keyword
	(#eq? @keyword "else"))
