<?php
return [
    '@class' => 'Gantry\\Component\\Config\\CompiledConfig',
    'timestamp' => 1748586788,
    'checksum' => 'df20cdd6a894a90759377951e812afa1',
    'files' => [
        'templates/g5_hydrogen/custom/config/default' => [
            'index' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/index.yaml',
                'modified' => 1748586448
            ],
            'layout' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/layout.yaml',
                'modified' => 1748586448
            ],
            'particles/branding' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/branding.yaml',
                'modified' => 1748586788
            ],
            'particles/content' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/content.yaml',
                'modified' => 1748586788
            ],
            'particles/contentarray' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/contentarray.yaml',
                'modified' => 1748586788
            ],
            'particles/copyright' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/copyright.yaml',
                'modified' => 1748586788
            ],
            'particles/custom' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/custom.yaml',
                'modified' => 1748586788
            ],
            'particles/date' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/date.yaml',
                'modified' => 1748586788
            ],
            'particles/logo' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/logo.yaml',
                'modified' => 1748586788
            ],
            'particles/menu' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/menu.yaml',
                'modified' => 1748586788
            ],
            'particles/messages' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/messages.yaml',
                'modified' => 1748586788
            ],
            'particles/mobile-menu' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/mobile-menu.yaml',
                'modified' => 1748586788
            ],
            'particles/module' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/module.yaml',
                'modified' => 1748586788
            ],
            'particles/position' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/position.yaml',
                'modified' => 1748586788
            ],
            'particles/sample' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/sample.yaml',
                'modified' => 1748586788
            ],
            'particles/social' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/social.yaml',
                'modified' => 1748586788
            ],
            'particles/spacer' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/spacer.yaml',
                'modified' => 1748586788
            ],
            'particles/totop' => [
                'file' => 'templates/g5_hydrogen/custom/config/default/particles/totop.yaml',
                'modified' => 1748586788
            ]
        ],
        'templates/g5_hydrogen/config/default' => [
            'particles/logo' => [
                'file' => 'templates/g5_hydrogen/config/default/particles/logo.yaml',
                'modified' => 1748586448
            ]
        ]
    ],
    'data' => [
        'particles' => [
            'sample' => [
                'caching' => [
                    'type' => 'static'
                ],
                'enabled' => '1'
            ],
            'branding' => [
                'caching' => [
                    'type' => 'static'
                ],
                'enabled' => '1',
                'content' => 'Powered by <a href="http://www.gantry.org/" title="Gantry Framework" class="g-powered-by">Gantry Framework</a>',
                'css' => [
                    'class' => 'branding'
                ]
            ],
            'copyright' => [
                'caching' => [
                    'type' => 'static'
                ],
                'enabled' => '1',
                'date' => [
                    'start' => 'now',
                    'end' => 'now'
                ],
                'owner' => ''
            ],
            'custom' => [
                'caching' => [
                    'type' => 'config_matches',
                    'values' => [
                        'twig' => '0',
                        'filter' => '0'
                    ]
                ],
                'enabled' => '1',
                'twig' => '0',
                'filter' => '0'
            ],
            'logo' => [
                'caching' => [
                    'type' => 'static'
                ],
                'enabled' => '1',
                'target' => '_self',
                'link' => '1',
                'url' => '',
                'image' => 'gantry-media://quetzalgt.png',
                'text' => '',
                'class' => 'gantry-logo',
                'height' => '',
                'svg' => ''
            ],
            'menu' => [
                'caching' => [
                    'type' => 'menu'
                ],
                'enabled' => '1',
                'menu' => '',
                'base' => '/',
                'startLevel' => '1',
                'maxLevels' => '0',
                'renderTitles' => '0',
                'hoverExpand' => '1',
                'mobileTarget' => '0',
                'forceTarget' => '0'
            ],
            'mobile-menu' => [
                'caching' => [
                    'type' => 'static'
                ],
                'enabled' => '1'
            ],
            'social' => [
                'caching' => [
                    'type' => 'static'
                ],
                'enabled' => '1',
                'css' => [
                    'class' => 'social'
                ],
                'target' => '',
                'display' => 'both',
                'title' => '',
                'items' => [
                    
                ]
            ],
            'spacer' => [
                'caching' => [
                    'type' => 'static'
                ],
                'enabled' => '1'
            ],
            'totop' => [
                'caching' => [
                    'type' => 'static'
                ],
                'enabled' => '1',
                'css' => [
                    'class' => 'totop'
                ],
                'icon' => '',
                'content' => '',
                'title' => ''
            ],
            'analytics' => [
                'enabled' => true,
                'ua' => [
                    'anonym' => false
                ]
            ],
            'assets' => [
                'enabled' => true
            ],
            'content' => [
                'enabled' => '1'
            ],
            'contentarray' => [
                'enabled' => '1',
                'article' => [
                    'filter' => [
                        'featured' => ''
                    ],
                    'limit' => [
                        'total' => 2,
                        'columns' => 2,
                        'start' => 0
                    ],
                    'display' => [
                        'pagination_buttons' => '',
                        'image' => [
                            'enabled' => 'intro'
                        ],
                        'text' => [
                            'type' => 'intro',
                            'limit' => '',
                            'formatting' => 'text',
                            'prepare' => '0'
                        ],
                        'edit' => '0',
                        'title' => [
                            'enabled' => 'show',
                            'limit' => ''
                        ],
                        'date' => [
                            'enabled' => 'published',
                            'format' => 'l, F d, Y'
                        ],
                        'read_more' => [
                            'enabled' => 'show',
                            'label' => '',
                            'css' => ''
                        ],
                        'author' => [
                            'enabled' => 'show'
                        ],
                        'category' => [
                            'enabled' => 'link'
                        ],
                        'hits' => [
                            'enabled' => 'show'
                        ]
                    ],
                    'sort' => [
                        'orderby' => 'publish_up',
                        'ordering' => 'ASC'
                    ]
                ],
                'css' => [
                    'class' => ''
                ],
                'extra' => [
                    
                ]
            ],
            'date' => [
                'enabled' => '1',
                'css' => [
                    'class' => 'date'
                ],
                'date' => [
                    'formats' => 'l, F d, Y'
                ]
            ],
            'frameworks' => [
                'enabled' => true,
                'jquery' => [
                    'enabled' => 0,
                    'ui_core' => 0,
                    'ui_sortable' => 0
                ],
                'bootstrap' => [
                    'enabled' => 0
                ],
                'mootools' => [
                    'enabled' => 0,
                    'more' => 0
                ]
            ],
            'lightcase' => [
                'enabled' => true
            ],
            'messages' => [
                'enabled' => '1'
            ],
            'module' => [
                'enabled' => '1',
                'chrome' => ''
            ],
            'position' => [
                'enabled' => '1',
                'chrome' => ''
            ]
        ],
        'page' => [
            'doctype' => 'html',
            'body' => [
                'class' => 'gantry',
                'attribs' => [
                    'class' => 'gantry'
                ],
                'layout' => [
                    'sections' => 0
                ]
            ],
            'fontawesome' => [
                'enable' => 1,
                'version' => 'fa4',
                'fa4_compatibility' => 1,
                'content_compatibility' => 1
            ]
        ],
        'styles' => [
            'accent' => [
                'color-1' => '#439a86',
                'color-2' => '#8f4dae'
            ],
            'base' => [
                'background' => '#ffffff',
                'text-color' => '#666666',
                'body-font' => 'roboto, sans-serif',
                'heading-font' => 'roboto, sans-serif'
            ],
            'breakpoints' => [
                'large-desktop-container' => '75rem',
                'desktop-container' => '60rem',
                'tablet-container' => '48rem',
                'large-mobile-container' => '30rem',
                'mobile-menu-breakpoint' => '48rem'
            ],
            'feature' => [
                'background' => '#ffffff',
                'text-color' => '#666666'
            ],
            'footer' => [
                'background' => '#ffffff',
                'text-color' => '#666666'
            ],
            'header' => [
                'background' => '#2a816d',
                'text-color' => '#ffffff'
            ],
            'main' => [
                'background' => '#ffffff',
                'text-color' => '#666666'
            ],
            'menu' => [
                'col-width' => '180px',
                'animation' => 'g-fade',
                'hide-on-mobile' => 0
            ],
            'navigation' => [
                'background' => '#439a86',
                'text-color' => '#ffffff',
                'overlay' => 'rgba(0, 0, 0, 0.4)'
            ],
            'offcanvas' => [
                'background' => '#354d59',
                'text-color' => '#ffffff',
                'width' => '17rem',
                'toggle-color' => '#ffffff',
                'toggle-visibility' => 1
            ],
            'showcase' => [
                'background' => '#354d59',
                'image' => '',
                'text-color' => '#ffffff'
            ],
            'subfeature' => [
                'background' => '#f0f0f0',
                'text-color' => '#666666'
            ]
        ],
        'index' => [
            'name' => 'default',
            'timestamp' => 1748586448,
            'version' => 7,
            'preset' => [
                'image' => 'gantry-admin://images/layouts/default.png',
                'name' => 'default',
                'timestamp' => 1748586448
            ],
            'positions' => [
                'header' => 'Header',
                'breadcrumbs' => 'Breadcrumbs',
                'footer' => 'Footer'
            ],
            'sections' => [
                'header' => 'Header',
                'navigation' => 'Navigation',
                'main' => 'Main',
                'footer' => 'Footer',
                'offcanvas' => 'Offcanvas'
            ],
            'particles' => [
                'logo' => [
                    'logo-5121' => 'Logo'
                ],
                'position' => [
                    'position-header' => 'Header',
                    'position-breadcrumbs' => 'Breadcrumbs',
                    'position-footer' => 'Footer'
                ],
                'menu' => [
                    'menu-5796' => 'Menu'
                ],
                'messages' => [
                    'system-messages-2992' => 'System Messages'
                ],
                'content' => [
                    'system-content-2169' => 'Page Content'
                ],
                'copyright' => [
                    'copyright-7251' => 'Copyright'
                ],
                'spacer' => [
                    'spacer-3923' => 'Spacer'
                ],
                'branding' => [
                    'branding-9502' => 'Branding'
                ],
                'mobile-menu' => [
                    'mobile-menu-5104' => 'Mobile-menu'
                ]
            ],
            'inherit' => [
                
            ]
        ],
        'layout' => [
            'version' => 2,
            'preset' => [
                'image' => 'gantry-admin://images/layouts/default.png',
                'name' => 'default',
                'timestamp' => 1748586448
            ],
            'layout' => [
                '/header/' => [
                    0 => [
                        0 => 'logo-5121 30',
                        1 => 'position-header 70'
                    ]
                ],
                '/navigation/' => [
                    0 => [
                        0 => 'menu-5796'
                    ]
                ],
                '/main/' => [
                    0 => [
                        0 => 'position-breadcrumbs'
                    ],
                    1 => [
                        0 => 'system-messages-2992'
                    ],
                    2 => [
                        0 => 'system-content-2169'
                    ]
                ],
                '/footer/' => [
                    0 => [
                        0 => 'position-footer'
                    ],
                    1 => [
                        0 => 'copyright-7251 40',
                        1 => 'spacer-3923 30',
                        2 => 'branding-9502 30'
                    ]
                ],
                'offcanvas' => [
                    0 => [
                        0 => 'mobile-menu-5104'
                    ]
                ]
            ],
            'structure' => [
                'header' => [
                    'attributes' => [
                        'boxed' => ''
                    ]
                ],
                'navigation' => [
                    'type' => 'section',
                    'attributes' => [
                        'boxed' => ''
                    ]
                ],
                'main' => [
                    'attributes' => [
                        'boxed' => ''
                    ]
                ],
                'footer' => [
                    'attributes' => [
                        'boxed' => ''
                    ]
                ]
            ],
            'content' => [
                'position-header' => [
                    'attributes' => [
                        'key' => 'header'
                    ]
                ],
                'position-breadcrumbs' => [
                    'attributes' => [
                        'key' => 'breadcrumbs'
                    ]
                ],
                'position-footer' => [
                    'attributes' => [
                        'key' => 'footer'
                    ]
                ]
            ]
        ]
    ]
];
