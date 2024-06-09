#let slides(
	title: none,
	subtitle: none,
	author: none,
	date: datetime.today(),
	beamer-format: (16, 9),
	theme-background: rgb("#00305D"),
	theme-text: white,
	font: "Open Sans",
	has-section-slides: true,
	doc
) = {
	// Variables for configuration.
	let scale = 2cm
	let width = beamer-format.at(0) * scale
	let height = beamer-format.at(1) * scale

	let theme-muted = theme-background.lighten(75%)
	let margin = (x: 2em, y: 4em);

	let background(color: theme-background) = (
		place(top + left, dx: - margin.x, dy: - margin.y)[
			#rect(
				width: 100% + 2 * margin.x, height: 100% + 2 * margin.y,
				fill: gradient.radial(color.lighten(50%).saturate(75%), color.lighten(20%)),
			),
			<background>
		]
	)

	let hasBackground(selector, loc) = query(selector, loc)
		.filter(l => l.location().page() == loc.page())
		.len() > 0

	// Setup.
	set document(
		title: title,
		author: author,
	)
	set text(
		font: font,
		size: 22pt,
	)
	set page(
		width: width,
		height: height,
		margin: margin,
		header: [
			#locate(loc => {
				let sections = query(heading.where(level: 1), loc)
				let offset = if (has-section-slides) { 1 } else { 0 }
				let link-offset = if (has-section-slides) { 0 } else { 1 }
				let sectionsWithPages = sections
					.enumerate(start: 1)
					.map(((i, s)) => {(
						let start = counter(page).at(s.location()).first() + offset,
						let stop = if (i < sections.len()) {
							counter(page).at(sections.at(i).location()).first()
						} else {
							counter(page).final(loc).first() + offset
						},
						return (pageRange: range(start, stop), label: s.body)
				)})

				if hasBackground(selector(<background>).after(loc), loc) == false {
					set text(
						size: 0.4em,
					)
					grid(
						columns: range(sections.len()).map(_ => 1fr),
						gutter: 1em,
						rows: 1,
						..sectionsWithPages.map(((pageRange, label)) => [
							#let is-active = pageRange.contains(loc.page()-1)
							#let color = if (is-active == true) {theme-background} else { theme-muted}
							#show link: set text(fill: color)
							#if pageRange.len() > 0 [
								#link((page: pageRange.first() + link-offset, x: 0em, y:0em), label)
							]
							#set align(horizon)
							#stack(
								dir: ltr,
								spacing: .5em,
								..pageRange.map(i => {
									let radius = if (loc.page() == i+1) {
											.3em
										} else {
											.15em
										}
									return box(height: .6em,
										link((page: i+1, x: 0em, y: 0em),
											circle(radius: radius, fill: color)
										)
									)
								})
							)
						])
					)
				}
			})
		],
		footer-descent: 2em,
		footer: [
			#locate(loc => {
				if hasBackground(selector(<background>).before(loc), loc) == false {
					set text(
						size: 0.4em,
						fill: theme-background
					)
					set align(horizon)
					grid(columns: (auto, auto, 1fr), rows: 2.5em, gutter: 1em, ..(
						box(image("_extensions/sarahzeller/tud/TU_Dresden_Logo_blau.svg", height: 2.5em)),
						[ #author #sym.dot.op #title],
						counter(page).display(
							"1 · 1",
							both: true,
						)
					))
				}
			})
		]
	)

	show link: l => {
		if type(l.dest) == "string" and l.dest.starts-with("http") {
			underline(l)
		} else {
			l
		}
	}

	show figure.caption: set text(size: 0.6em)

	show "->": sym.arrow

	//format code blocks
	show raw.where(block: true): set text(size: 0.8em)


		show heading.where(level: 1): title => {
			if has-section-slides == true {
				pagebreak()
				block(width: 100%, height: 100%)[
					#set align(horizon)
					#background()
					#text(
						fill: theme-text,
						title
					)
				]
			} else {
				pagebreak(weak: true)
			}
		}

	show heading.where(level: 2): title => {
		pagebreak(weak: true)
		title
	}

	// Title page.
	background()
	rect(width: 100%, height: 100%, stroke: none)[
			#image("_extensions/sarahzeller/tud/TU_Dresden_Logo_weiss.svg", width: 15%)
			#set text(fill: theme-text)
			#set align(horizon)
			#text(size: 50pt, weight: "bold", title)
			#linebreak()
			#text(size: 30pt, subtitle)
			#v(2em)
			#text(size: 25pt, author)
			#linebreak()
			#text(size: 15pt, date.display("[day].[month].[year]"))
	]
	pagebreak(weak: true)
	counter(page).update(1)

	// Actual content.
	doc
}