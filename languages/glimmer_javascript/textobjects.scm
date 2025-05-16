; Manually copied from upstream: https://github.com/zed-industries/zed/tree/6cac0b33dcd9b6af04f9d8dd21c8fa00937af97c/crates/languages/src/javascript
(comment)+ @comment.around

(function_declaration
    body: (_
        "{"
        (_)* @function.inside
        "}")) @function.around

(method_definition
    body: (_
        "{"
        (_)* @function.inside
        "}")) @function.around

(function_expression
    body: (_
        "{"
        (_)* @function.inside
        "}")) @function.around

(arrow_function
    body: (statement_block
        "{"
        (_)* @function.inside
        "}")) @function.around

(arrow_function) @function.around

(generator_function
    body: (_
        "{"
        (_)* @function.inside
        "}")) @function.around

(generator_function_declaration
    body: (_
        "{"
        (_)* @function.inside
        "}")) @function.around

(class_declaration
    body: (_
        "{"
        [(_) ";"?]* @class.inside
        "}" )) @class.around

(class
    body: (_
        "{"
        [(_) ";"?]* @class.inside
        "}" )) @class.around
