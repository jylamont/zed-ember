; Manually copied from upstream: https://github.com/zed-industries/zed/tree/6cac0b33dcd9b6af04f9d8dd21c8fa00937af97c/crates/languages/src/typescript
(internal_module
    "namespace" @context
    name: (_) @name) @item

(enum_declaration
    "enum" @context
    name: (_) @name) @item

(type_alias_declaration
    "type" @context
    name: (_) @name) @item

(function_declaration
    "async"? @context
    "function" @context
    name: (_) @name
    parameters: (formal_parameters
      "(" @context
      ")" @context)) @item

(interface_declaration
    "interface" @context
    name: (_) @name) @item

(export_statement
    (lexical_declaration
        ["let" "const"] @context
        (variable_declarator
            name: (_) @name) @item))

(program
    (lexical_declaration
        ["let" "const"] @context
        (variable_declarator
            name: (_) @name) @item))

(class_declaration
    "class" @context
    name: (_) @name) @item

(abstract_class_declaration
    "abstract" @context
    "class" @context
    name: (_) @name) @item

(method_definition
    [
        "get"
        "set"
        "async"
        "*"
        "readonly"
        "static"
        (override_modifier)
        (accessibility_modifier)
    ]* @context
    name: (_) @name
    parameters: (formal_parameters
      "(" @context
      ")" @context)) @item

(public_field_definition
    [
        "declare"
        "readonly"
        "abstract"
        "static"
        (accessibility_modifier)
    ]* @context
    name: (_) @name) @item

; Add support for (node:test, bun:test and Jest) runnable
(
    (call_expression
        function: [
            (identifier) @_name
            (member_expression
                object: [
                    (identifier) @_name
                    (member_expression object: (identifier) @_name)
                ]
            )
        ] @context
        (#any-of? @_name "it" "test" "describe" "context" "suite")
        arguments: (
            arguments . (string (string_fragment) @name)
        )
    )
) @item

(comment) @annotation

(class_body
  (glimmer_template
    (glimmer_opening_tag) @name
  ) @item
)
