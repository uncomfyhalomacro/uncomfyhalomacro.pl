import { QuartzComponent, QuartzComponentConstructor, QuartzComponentProps } from "./types"
import style from "./styles/webring.scss"
import { i18n } from "../i18n"

interface Options {
  links: Record<string, string>
}

export default ((opts?: Options) => {
  const Webring: QuartzComponent = ({ displayClass, cfg }: QuartzComponentProps) => {
    const year = new Date().getFullYear()
    const links = opts?.links ?? []
    return (
      <div class="webring">
        <h3>Webring</h3>
        <ul class="overflow">
          {Object.entries(links).map(([text, link]) => (
            <li>
              <a href={link} target="_blank">
                {text}
              </a>
            </li>
          ))}
        </ul>
      </div>
    )
  }

  Webring.css = style
  return Webring
}) satisfies QuartzComponentConstructor
