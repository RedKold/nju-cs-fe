import { defineConfig } from 'vitepress'

/**
 * 站点部署在 https://redkold.github.io/nju-cs-fe/
 * BASE 必须和仓库名一致，否则部署后所有资源都会 404。
 * 如果仓库名改成 <用户名>.github.io，把 base 改成 '/' 即可。
 */
const BASE = '/nju-cs-fe/'

export default defineConfig({
  lang: 'zh-CN',
  title: 'CS & FE Wiki',
  description: '计算机基础与前端的个人知识库',
  base: BASE,

  cleanUrls: true,
  lastUpdated: true,

  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: `${BASE}logo.svg` }],
    ['meta', { name: 'theme-color', content: '#3e63dd' }]
  ],

  markdown: {
    lineNumbers: true
  },

  themeConfig: {
    logo: '/logo.svg',

    nav: [
      { text: '首页', link: '/' },
      {
        text: '知识板块',
        items: [
          { text: '前端', link: '/web/' },
          { text: '计算机基础', link: '/cs/' },
          { text: '工程化', link: '/engineering/' }
        ]
      }
    ],

    sidebar: {
      '/web/': [
        {
          text: '前端',
          items: [
            { text: '总览', link: '/web/' },
            { text: 'HTML', link: '/web/html' },
            { text: 'CSS', link: '/web/css' },
            { text: 'JavaScript', link: '/web/javascript' }
          ]
        }
      ],
      '/cs/': [
        {
          text: '计算机基础',
          items: [
            { text: '总览', link: '/cs/' },
            { text: '数据结构与算法', link: '/cs/algorithm' },
            { text: '计算机网络', link: '/cs/network' }
          ]
        }
      ],
      '/engineering/': [
        {
          text: '工程化',
          items: [
            { text: '总览', link: '/engineering/' },
            { text: 'Git 工作流', link: '/engineering/git' },
            { text: '构建与打包', link: '/engineering/build' }
          ]
        }
      ]
    },

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

    // 换成你自己的 GitHub 地址后，右上角会显示仓库链接，页面底部会有「编辑此页」
    socialLinks: [
      { icon: 'github', link: 'https://github.com/RedKold/nju-cs-fe' }
    ],
    editLink: {
      pattern: 'https://github.com/RedKold/nju-cs-fe/edit/main/docs/:path',
      text: '在 GitHub 上编辑此页'
    },

    footer: {
      message: '基于 VitePress 构建',
      copyright: 'Copyright © 2026 CS & FE Wiki'
    }
  }
})
