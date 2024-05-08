#show:
$if(title)$
  title: "$title$",
$endif$
$if(abstract)$
  abstract: [$abstract$],
$endif$
$if(by-author)$
authors: (
  $for(by-author)$
  (
    name: "$it.name.literal$",
    email: "$it.email",
    $for(it.affiliations/first)$
    department: [$it.department$],
    organization: [$it.name$],
    $endfor$
  )$sep$,
  $endfor$
),
$endif$
$if(index-terms)$
  index-terms: ($for(index-terms)$"$it$"$sep$, $endfor$),
$endif$