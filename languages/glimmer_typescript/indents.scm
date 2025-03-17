; Manually copied from upstream: https://github.com/zed-industries/zed/tree/6cac0b33dcd9b6af04f9d8dd21c8fa00937af97c/crates/languages/src/typescript
[
    (call_expression)
    (assignment_expression)
    (member_expression)
    (lexical_declaration)
    (variable_declaration)
    (assignment_expression)
    ; below handled by  `(_ "{" "}" @end) @indent`
    ; (if_statement)
    ; (for_statement)
    ; (while_statement)
] @indent

(_ "[" "]" @end) @indent
(_ "<" ">" @end) @indent
(_ "{" "}" @end) @indent
(_ "(" ")" @end) @indent

(glimmer_template
  (glimmer_opening_tag)
  (glimmer_closing_tag) @end
) @indent
