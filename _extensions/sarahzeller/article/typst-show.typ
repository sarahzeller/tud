#show: doc => ica-abstract(
  $if(title)$
    title: "$title$",
  $endif$
  $if(by-authors)$
  authors: (
    $for(by-authors)$
    (
      name: "$it.name$",
      corresponding: $if(it.corresponding)$ $it.corresponding$ $else$ false $endif$,
      affiliations: (
      
    $for(it.affiliations/first)$id: $it.id$,
    email: [$it.email$],
      )
    $endfor$
    ),
    $endfor$
  ),
  $endif$
  $if(affiliations)$
  affiliations: (
    $for(affiliations)$
      "$it.name$",
    $endfor$
  ),
  $endif$
  $if(keywords)$
  keywords: (
    $for(keywords)$
      "$it$",
    $endfor$
  ),
  $endif$
  $if(jel-codes)$
  jel-codes: (
    $for(jel-codes)$
      "$it$",
    $endfor$
  ),
  $endif$
  $if(mainfont)$
  mainfont: "$mainfont$",
  $endif$
  doc,
)