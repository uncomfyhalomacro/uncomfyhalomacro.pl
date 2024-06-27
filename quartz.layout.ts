import { PageLayout, SharedLayout } from "./quartz/cfg"
import * as Component from "./quartz/components"
import { pathToRoot } from "../util/path"


// components shared across all pages
export const sharedPageComponents: SharedLayout = {
  head: Component.Head(),
  header: [
    Component.PageTitle(),
    Component.Darkmode(),
    Component.Search(),
  ],
  footer: Component.Footer({
  }),
}

// components for pages that display a single page (e.g. a single note)
export const defaultContentPageLayout: PageLayout = {
  beforeBody: [
    Component.Graph({
         localGraph: {
         drag: true, // whether to allow panning the view around
         zoom: true, // whether to allow zooming in and out
         depth: 1, // how many hops of notes to display
         scale: 1.2, // default view scale
         repelForce: 0.5, // how much nodes should repel each other
         centerForce: 1.0, // how much force to use when trying to center the nodes
         linkDistance: 30, // how long should the links be by default?
         fontSize: 0.6, // what size should the node labels be?
         opacityScale: 1, // how quickly do we fade out the labels when zooming out?
         removeTags: [], // what tags to remove from the graph
         showTags: true, // whether to show tags in the graph
       },
       globalGraph: {
         drag: true,
         zoom: true,
         depth: -1,
         scale: 1.2,
         repelForce: 0.2,
         centerForce: 1.3,
         linkDistance: 15,
         fontSize: 0.6,
         opacityScale: 1,
         removeTags: [], // what tags to remove from the graph
         showTags: true, // whether to show tags in the graph
       },
    }),
    Component.Breadcrumbs(),
    Component.ArticleTitle(),
    Component.ContentMeta(),
    Component.TagList(),
  ],
  left: [
    Component.MobileOnly(Component.Spacer()),
    Component.DesktopOnly(Component.Explorer()),
  ],
  right: [
    Component.Webring({
    	links: {
      "Why People are Angry over Go 1.23 Iterators": "https://www.gingerbill.org/article/2024/06/17/go-iterator-design/",
      "My RSS feed has been upgraded ✨": "https://www.roboleary.net/blog/feed-update/",
      "Programming at the edge with Fastly Compute": "https://www.integralist.co.uk/posts/fastly-compute-caching/",
      "israeli national police found trying to purchase stalkerware - #FuckStalkerware pt. 7": "https://maia.crimew.gay/posts/fuckstalkerware-7/",
      "Obsidian Freeform": "https://macwright.com/2024/06/02/freeform.html",
      "Defending myself against defensive writing": "https://pcloadletter.dev/blog/bad-networks/",
      "Writing a Unix clone in about a month": "https://drewdevault.com/2024/05/24/2024-05-24-Bunnix.html",
      "Quadlet: Running Podman containers under systemd": "https://mo8it.com/blog/quadlet/",
      "Regex engine internals as a library": "https://blog.burntsushi.net/regex-internals/",
      "Eradicating image authentication injection from the entire internet": "https://samcurry.net/eradicating-image-authentication-injection-from-the-entire-internet",
    	},
    }),
    Component.DesktopOnly(Component.TableOfContents()),
    Component.Backlinks(),
  ],
}

// components for pages that display lists of pages  (e.g. tags or folders)
export const defaultListPageLayout: PageLayout = {
  beforeBody: [Component.Breadcrumbs(), Component.ArticleTitle(), Component.ContentMeta()],
  left: [
    Component.PageTitle(),
    Component.MobileOnly(Component.Spacer()),
    Component.Search(),
    Component.Darkmode(),
    Component.DesktopOnly(Component.Explorer()),
  ],
  right: [],
}
