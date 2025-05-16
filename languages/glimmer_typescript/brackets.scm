; Manually copied from upstream: https://github.com/zed-industries/zed/tree/6cac0b33dcd9b6af04f9d8dd21c8fa00937af97c/crates/languages/src/typescript
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
