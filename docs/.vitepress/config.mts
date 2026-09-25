import { defineConfig } from 'vitepress'
import { generateNav, generateSidebar } from './sidebar'

/**
 * 站点部署在 https://redkold.github.io/nju-cs-fe/
 * BASE 必须和仓库名一致，否则部署后所有资源都会 404。
 * 如果仓库名改成 <用户名>.github.io，把 base 改成 '/' 即可。
 */
const BASE = '/nju-cs-fe/'

export default defineConfig({
  lang: 'zh-CN',
  title: '计算机金融实验班',
  description: '南京大学计算机金融实验班资料库：课程资料、推免与出国经验',
  base: BASE,

  cleanUrls: true,
  lastUpdated: true,

  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: `${BASE}logo.svg` }],
    ['meta', { name: 'theme-color', content: '#5b21b6' }]
  ],

  markdown: {
    lineNumbers: true
  },

  themeConfig: {
    logo: '/logo.svg',

    // 导航与侧边栏都由目录结构自动生成，见 sidebar.ts
    nav: generateNav(),
    sidebar: generateSidebar(),

    search: {
      provider: 'local',
      options: {
        translations: {
          button: {
            buttonText: '搜索文档',
            buttonAriaLabel: '搜索文档'
          },
          modal: {
            noResultsText: '没有找到结果',
            resetButtonTitle: '清除条件',
            displayDetails: '显示详情',
            footer: {
              selectText: '选择',
              navigateText: '切换',
              closeText: '关闭'
            }
          }
        }
      }
    },

    outline: { level: [2, 3], label: '本页目录' },
    docFooter: { prev: '上一篇', next: '下一篇' },
    lastUpdated: { text: '最后更新于' },
    returnToTopLabel: '回到顶部',
    sidebarMenuLabel: '目录',
    darkModeSwitchLabel: '外观',
    lightModeSwitchTitle: '切换到浅色模式',
    darkModeSwitchTitle: '切换到深色模式',

    socialLinks: [
      { icon: 'github', link: 'https://github.com/RedKold/nju-cs-fe' }
    ],
    editLink: {
      pattern: 'https://github.com/RedKold/nju-cs-fe/edit/main/docs/:path',
      text: '在 GitHub 上编辑此页'
    },

    footer: {
      message: '内容由同学共同维护，涉及硬性规定请以学院与教务处官方文件为准',
      copyright: 'Copyright © 2026 南京大学计算机金融实验班'
    }
  }
})
