; Angle bracket elements
(element_node
  (element_node_start) @start
  (element_node_end)? @end) @indent

; Mustache blocks
(block_statement
  (block_statement_start) @start
  (block_statement_end)? @end) @indent

; Matches `else if` statements
(block_statement
	(mustache_statement
		(helper_invocation
			helper: (identifier) @_identifier (#match? @_identifier "else")
			argument: (identifier) @_argIdentifier (#match? @_argIdentifier "if"))
	) @start
) @indent

; Matches `else` statements
(block_statement
	(mustache_statement
		(
      (identifier) @_identifier
      (#match? @_identifier "else")
    )
	) @start
) @indent
