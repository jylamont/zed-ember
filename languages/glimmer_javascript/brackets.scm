("(" @open ")" @close)
("[" @open "]" @close)
("{" @open "}" @close)
("<" @open ">" @close)
("\"" @open "\"" @close)
("'" @open "'" @close)
("`" @open "`" @close)

("</" @open ">" @close)
(
  (glimmer_template
    (glimmer_opening_tag) @open
    (glimmer_closing_tag) @close
  ) (#set! newline.only)
)
