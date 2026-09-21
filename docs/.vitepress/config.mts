import { defineConfig } from 'vitepress'

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

    nav: [
      { text: '使用指南', link: '/guide/' },
      { text: '课程资料', link: '/courses/' },
      {
        text: '升学',
        items: [
          { text: '推免', link: '/postgrad/' },
          { text: '出国', link: '/abroad/' }
        ]
      },
      { text: '实习就业', link: '/career/' },
      { text: '资源区', link: '/resources/' }
    ],

    sidebar: {
      '/guide/': [
        {
          text: '使用指南',
          items: [
            { text: '资料库使用说明', link: '/guide/' },
            { text: '培养方案与课程地图', link: '/guide/curriculum' },
            { text: '四年时间线', link: '/guide/roadmap' }
          ]
        }
      ],
      '/courses/': [
        {
          text: '课程资料',
          items: [
            { text: '课程资料总览', link: '/courses/' },
            { text: '数学与统计', link: '/courses/math' },
            { text: '计算机', link: '/courses/cs' },
            { text: '金融与经济', link: '/courses/finance' }
          ]
        },
        {
          text: '配套资源',
          items: [
            { text: '教材与课件', link: '/resources/textbooks' },
            { text: '历年真题', link: '/resources/past-exams' }
          ]
        }
      ],
      '/postgrad/': [
        {
          text: '推免',
          items: [
            { text: '推免总览', link: '/postgrad/' },
            { text: '政策与资格', link: '/postgrad/policy' },
            { text: '夏令营', link: '/postgrad/summer-camp' },
            { text: '材料准备', link: '/postgrad/materials' },
            { text: '面试经验', link: '/postgrad/interview' }
          ]
        },
        {
          text: '相关',
          items: [
            { text: '四年时间线', link: '/guide/roadmap' },
            { text: '模板下载', link: '/resources/templates' }
          ]
        }
      ],
      '/abroad/': [
        {
          text: '出国',
          items: [
            { text: '出国总览', link: '/abroad/' },
            { text: '申请时间线', link: '/abroad/timeline' },
            { text: '选校与文书', link: '/abroad/application' },
            { text: '语言考试', link: '/abroad/language-test' }
          ]
        },
        {
          text: '相关',
          items: [
            { text: '材料准备', link: '/postgrad/materials' },
            { text: '模板下载', link: '/resources/templates' }
          ]
        }
      ],
      '/career/': [
        {
          text: '实习与就业',
          items: [
            { text: '总览', link: '/career/' },
            { text: '量化方向', link: '/career/quant' }
          ]
        },
        {
          text: '相关',
          items: [
            { text: '课程资料', link: '/courses/' },
            { text: '材料准备', link: '/postgrad/materials' }
          ]
        }
      ],
      '/resources/': [
        {
          text: '资源区',
          items: [
            { text: '资源总索引', link: '/resources/' },
            { text: '教材与课件', link: '/resources/textbooks' },
            { text: '历年真题', link: '/resources/past-exams' },
            { text: '模板', link: '/resources/templates' }
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
