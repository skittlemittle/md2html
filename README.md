# md2html

a very simple md to html converter written in SML/NJ,
a few things are missing (formatting inside list elements doesnt happen)
and it kind of mangles text here and there but idc.

the actual conversion code is in `markdown.sml`, `mdtohtml.sml` is just file loading and writing etc

## features
- headers
- lists
- horizontal rule
- `inline code`
- fenced code (works in the tests, doesnt work on real files idk why)
- links like [this one](https://www.youtube.com/watch?v=dgha9S39Y6M)
- **bold text**
- *italics*
- and paragraphs (it even autocloses dangling p tags)

## using it
- get SML/NJ, i wrote this on `v110.99.4`

- run `sml mdtohtml.sml <input file name>`

- close the sml interpreter

- the generated html is in `out.html`

### running tests

`sml markdown.sml tests.sml`
