#let ica-abstract(title: "", authors: (), affiliations: (), keywords: none, jel-codes: none, mainfont: "Open Sans", bibliography-file: none, body) = {
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

  set text(size: base-font-size, font: mainfont, lang: "en")
  show par: set block(spacing: 1.4em)
  set par(justify: true, leading: .5em)

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
                [ -- #link("mailto:" + repr(a.email).replace(regex("\\[|\\]|\\(|\\)"), "").split(", ").join("") )]
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
    pad(top: .5em, [*Keywords:* #keywords.join(", ")])
  }
  if jel-codes != none {
    [*JEL codes:* #jel-codes.join(", ")]
  }

  body
}