# tud presentations

A template for a typst or beamer presentation in quarto, styled for the TUD.

## typst look
![](tud-typst.PNG)

## beamer look
![](tud-beamer.PNG)

## Installing

This will install only the extension:

```bash
quarto add sarahzeller/tud
```

If you want to have a template installed, you can use the following command:

```bash
quarto use template sarahzeller/tud
```

## Using 

Refer to `template.qmd` for how to use the extension.
For further information on beamer options, please refer to the [quarto](https://quarto.org/docs/reference/formats/presentations/beamer.html) website.

## References

Please write in the YAML header which references you want to use, like so:

```
bibliography: references.bib
```
### Typst

So far, references are always rendered with a header at the first level.
That means that when `has_section_slides: true`, the references have an own section.
When `has_section_slides: false`, the references are rendered on the last slide(s), but without a slide title.


### LaTeX

If you're using *references*, please use a header at the second level (`## References`).
As in the template, please add the following lines then to place the references exactly there.
Otherwise, the references by default show up at the last slide.

```
::: {#refs}
:::
```


