#let ica-abstract(title: "", authors: (), affiliations: (), keywords: none, bibliography-file: none, body) = {
  // Set the document's basic properties.
  set document(
    title: title,
    author: authors.first().name,
    keywords: if keywords != none { keywords} else { "" }
  )
  set page(
    margin: (x: 20mm, top: 25mm, bottom: 28mm),
    header-ascent: 0%,
    header: locate(
        loc => if (loc.page() == 1) {
          image("ica-logo.svg", height: 1.19cm)
          line(length: 100%, stroke: .4pt)
        } else {
          align(end, {
            counter(page).display("1 of 1", both: true)
            v(2em)
          })
        }
    )
  )

  let base-font-size = 10pt

  set text(font: ("Times New Roman"), size: base-font-size, lang: "en")
  show par: set block(spacing: 1.4em)
  set par(justify: true, leading: .5em)

  show heading: it => {
    set block(spacing: 0pt)
    set text(size: base-font-size)
    it
  }

  pad(y: 2em,
      text(weight: "bold", 18pt, [
        #title
  ]))

  pad(
    top: .5em,
    bottom: .25em,
    [
      #set text(size: 12pt)
      #authors.map(
        (author) => {
          let affiliations = if (type(author.affiliations) != array) { (author.affiliations,)
          } else {author.affiliations}
          let corresponding-mark = if (
            author.keys().contains("corresponding") and author.corresponding == true
          ) { "*" } else { none }
          return [#author.name #super(affiliations.map((d) => {numbering("a", d.id)}).join(", "))#corresponding-mark]
        },
      ).join(", ")
    ],
  )

  pad(
    y: .25em,
    {
      set text(style: "italic", size: 9pt)
      for (i, affiliation) in affiliations.enumerate(start: 1) {
        let affiliation-authors = authors.fold((), (acc, author) => {
          let affiliations = if type(author.affiliations) != array {
            (author.affiliations,)
          } else { author.affiliations }
          for a in affiliations {
            if (a.id == i) {
              let email = if a.keys().contains("email") {
                [ -- #link("mailto:" + a.email)]
              } else { "" }
              acc.push([#author.name #email])
            }
          }
          acc
        })
        block(
          spacing: .5em,
          [
            #super(numbering("a", i))
            #affiliation#if affiliation-authors != none {
              [, #affiliation-authors.join(", ")]}
          ]
        )
      }
    },
  )

  text(size: 9pt, [\* Corresponding author])

  line(length: 100%, stroke: 0.4pt)

  if keywords != none {
    pad(y: .5em, [*Keywords:* #keywords.join(", ")])
  }

  heading([Abstract:])

  body

  show bibliography: it => {
    set block(spacing: .8em)
    it
  }

  if (bibliography-file != none) {
      bibliography(
      bibliography-file,
      title: "References",
      // Not exactly right yet, perhaps create a custom style?
      // using ica.bst file which itself is based on a isprs style (see https://github.com/citation-style-language for public collection)
      style: "elsevier-harvard",
  )}
}