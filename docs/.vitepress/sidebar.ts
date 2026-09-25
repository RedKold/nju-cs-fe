import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'
import type { DefaultTheme } from 'vitepress'

/**
 * 侧边栏和顶部导航根据 docs/ 的目录结构自动生成，不需要手工维护列表。
 *
 * 新增页面：把 .md 放进对应板块目录即可，它会自动出现在侧边栏。
 *
 * 控制顺序：在文件开头加 frontmatter
 *   ---
 *   order: 3
 *   ---
 * 没写 order 的排在写了 order 的后面，index.md 永远排第一。
 *
 * 侧边栏显示的文字：优先取 frontmatter 里的 title，没有就取正文第一个一级标题，
 * 再没有才退回文件名。
 */

const DOCS_ROOT = fileURLToPath(new URL('..', import.meta.url))

interface Section {
  /** docs/ 下的目录名 */
  dir: string
  /** 导航和侧边栏里显示的名字 */
  text: string
  /** 填了就收进顶部导航的下拉菜单，同名的归为一组 */
  group?: string
}

/** 板块清单。新增一个板块目录时，在这里加一行即可。 */
const SECTIONS: Section[] = [
  { dir: 'guide', text: '使用指南' },
  { dir: 'courses', text: '课程资料' },
  { dir: 'postgrad', text: '推免', group: '升学' },
  { dir: 'abroad', text: '出国', group: '升学' },
  { dir: 'career', text: '实习与就业' },
  { dir: 'resources', text: '资源区' }
]

/**
 * 跨板块的「相关页面」分组。这类链接很少变动，所以集中写在这里。
 * 不需要的话，把 RELATED 清空即可，不影响侧边栏生成。
 */
const RELATED_LABEL = '相关页面'
const RELATED: Record<string, DefaultTheme.SidebarItem[]> = {
  courses: [
    { text: '教材与课件', link: '/resources/textbooks' },
    { text: '历年真题', link: '/resources/past-exams' }
  ],
  postgrad: [
    { text: '四年时间线', link: '/guide/roadmap' },
    { text: '模板下载', link: '/resources/templates' }
  ],
  abroad: [
    { text: '材料准备', link: '/postgrad/materials' },
    { text: '模板下载', link: '/resources/templates' }
  ],
  career: [
    { text: '课程资料', link: '/courses/' },
    { text: '材料准备', link: '/postgrad/materials' }
  ]
}

interface Page {
  text: string
  link: string
  order: number
}

/** 去掉 frontmatter 与代码块，避免把代码里的 # 注释误当成一级标题 */
function stripNoise(raw: string): string {
  return raw
    .replace(/^---\r?\n[\s\S]*?\r?\n---\r?\n?/, '')
    .replace(/```[\s\S]*?```/g, '')
}

function parsePage(file: string, urlDir: string): Page {
  const raw = fs.readFileSync(file, 'utf8')
  const name = path.basename(file, '.md')

  let text = ''
  let order = 999

  const frontmatter = raw.match(/^---\r?\n([\s\S]*?)\r?\n---/)
  if (frontmatter) {
    const title = frontmatter[1].match(/^title:\s*(.+?)\s*$/m)
    if (title) text = title[1].replace(/^["']|["']$/g, '')
    const num = frontmatter[1].match(/^order:\s*(\d+)/m)
    if (num) order = Number(num[1])
  }

  if (!text) {
    const h1 = stripNoise(raw).match(/^#\s+(.+?)\s*$/m)
    if (h1) text = h1[1]
  }
  if (!text) text = name

  const isIndex = name === 'index'
  return {
    text,
    link: isIndex ? urlDir : `${urlDir}${name}`,
    order: isIndex ? -1 : order
  }
}

/** 目录名转成可读标题：summer-camp → summer camp */
function dirLabel(name: string): string {
  return name.replace(/[-_]/g, ' ')
}

function collect(absDir: string, urlDir: string): DefaultTheme.SidebarItem[] {
  const pages: Page[] = []
  const subdirs: DefaultTheme.SidebarItem[] = []

  for (const entry of fs.readdirSync(absDir, { withFileTypes: true })) {
    const abs = path.join(absDir, entry.name)
    if (entry.isDirectory()) {
      const items = collect(abs, `${urlDir}${entry.name}/`)
      if (items.length) {
        subdirs.push({ text: dirLabel(entry.name), items, collapsed: false })
      }
    } else if (entry.isFile() && entry.name.endsWith('.md')) {
      pages.push(parsePage(abs, urlDir))
    }
  }

  pages.sort((a, b) => a.order - b.order || a.text.localeCompare(b.text, 'zh-Hans-CN'))

  return [
    ...pages.map(({ text, link }) => ({ text, link })),
    ...subdirs
  ]
}

export function generateSidebar(): Record<string, DefaultTheme.SidebarItem[]> {
  const sidebar: Record<string, DefaultTheme.SidebarItem[]> = {}

  for (const section of SECTIONS) {
    const abs = path.join(DOCS_ROOT, section.dir)
    if (!fs.existsSync(abs)) continue

    const groups: DefaultTheme.SidebarItem[] = [
      { text: section.text, items: collect(abs, `/${section.dir}/`) }
    ]

    const related = RELATED[section.dir]
    if (related && related.length) {
      groups.push({ text: RELATED_LABEL, items: related })
    }

    sidebar[`/${section.dir}/`] = groups
  }

  return sidebar
}

export function generateNav(): DefaultTheme.NavItem[] {
  const nav: DefaultTheme.NavItem[] = []
  const dropdowns = new Map<string, DefaultTheme.NavItem[]>()

  for (const section of SECTIONS) {
    const link = `/${section.dir}/`

    if (!section.group) {
      nav.push({ text: section.text, link })
      continue
    }

    let items = dropdowns.get(section.group)
    if (!items) {
      items = []
      dropdowns.set(section.group, items)
      nav.push({ text: section.group, items })
    }
    items.push({ text: section.text, link })
  }

  return nav
}
