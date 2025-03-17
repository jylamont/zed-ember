; Manually copied from upstream: https://github.com/zed-industries/zed/tree/6cac0b33dcd9b6af04f9d8dd21c8fa00937af97c/crates/languages/src/javascript

(
    (comment)* @context
    .
    [
        (export_statement
            (function_declaration
                "async"? @name
                "function" @name
                name: (_) @name))
        (function_declaration
            "async"? @name
            "function" @name
            name: (_) @name)
    ] @item
)

(
    (comment)* @context
    .
    [
        (export_statement
            (class_declaration
                "class" @name
                name: (_) @name))
        (class_declaration
            "class" @name
            name: (_) @name)
    ] @item
)

;(
;    (comment)* @context
;    .
;    [
;        (export_statement
;            (interface_declaration
;                "interface" @name
;                name: (_) @name))
;        (interface_declaration
;            "interface" @name
;            name: (_) @name)
;    ] @item
;)

;(
;    (comment)* @context
;    .
;    [
;        (export_statement
;            (enum_declaration
;                "enum" @name
;                name: (_) @name))
;        (enum_declaration
;            "enum" @name
;            name: (_) @name)
;    ] @item
;)

(
    (comment)* @context
    .
    (method_definition
        [
            "get"
            "set"
            "async"
            "*"
            "static"
            ]* @name
        name: (_) @name) @item
)
