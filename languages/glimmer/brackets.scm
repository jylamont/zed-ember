("{{" @open "}}" @close)
("{{" @open "~}}" @close)
("{{#" @open "}}" @close)
("{{#" @open "~}}" @close)
("{{~#" @open "}}" @close)
("{{~#" @open "~}}" @close)
("{{~" @open "~}}" @close)
("{{~" @open "}}" @close)
("{{/" @open "}}" @close)
("{{/" @open "~}}" @close)
("{{~/" @open "~}}" @close)
("{{~/" @open "}}" @close)
("(" @open ")" @close)
("<" @open "/>" @close)
("</" @open ">" @close)
("<" @open ">" @close)
("\"" @open "\"" @close)

; Fixes auto indenting when pressing enter in-between two tags `<div>|</div>`
(
  (element_node
    (element_node_start) @open
    (element_node_end) @close
  ) (#set! newline.only)
)

(
  (block_statement
    (block_statement_start) @open
    (block_statement_end) @close
  ) (#set! newline.only)
)
