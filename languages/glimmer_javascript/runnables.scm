; Manually copied from upstream: https://github.com/zed-industries/zed/tree/6cac0b33dcd9b6af04f9d8dd21c8fa00937af97c/crates/languages/src/javascript
; Add support for (node:test, bun:test and Jest) runnable
; Function expression that has `it`, `test` or `describe` as the function name
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
        ]
        (#any-of? @_name "it" "test" "describe" "context" "suite" "module")
        arguments: (
            arguments . (string (string_fragment) @run)
        )
    ) @_js-test

    (#set! tag js-test)
)
