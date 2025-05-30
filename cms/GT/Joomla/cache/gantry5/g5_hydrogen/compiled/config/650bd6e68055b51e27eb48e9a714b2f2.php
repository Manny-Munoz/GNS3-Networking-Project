<?php
return [
    '@class' => 'Gantry\\Component\\Config\\CompiledConfig',
    'timestamp' => 1748586691,
    'checksum' => '74f9fe11614994a1152089418d98447e',
    'files' => [
        'templates/g5_hydrogen/custom/config/_offline' => [
            'index' => [
                'file' => 'templates/g5_hydrogen/custom/config/_offline/index.yaml',
                'modified' => 1748586448
            ],
            'layout' => [
                'file' => 'templates/g5_hydrogen/custom/config/_offline/layout.yaml',
                'modified' => 1748586448
            ]
        ]
    ],
    'data' => [
        'index' => [
            'name' => '_offline',
            'timestamp' => 1748586448,
            'version' => 7,
            'preset' => [
                'image' => 'gantry-admin://images/layouts/offline.png',
                'name' => '_offline',
                'timestamp' => 1748586448
            ],
            'positions' => [
                'footer' => 'Footer'
            ],
            'sections' => [
                'header' => 'Header',
                'main' => 'Main',
                'footer' => 'Footer'
            ],
            'particles' => [
                'logo' => [
                    'logo-4995' => 'Logo'
                ],
                'spacer' => [
                    'spacer-5105' => 'Spacer',
                    'spacer-3323' => 'Spacer'
                ],
                'messages' => [
                    'system-messages-4931' => 'System Messages'
                ],
                'content' => [
                    'system-content-9740' => 'Page Content'
                ],
                'position' => [
                    'position-footer' => 'Footer'
                ],
                'copyright' => [
                    'copyright-5260' => 'Copyright'
                ],
                'branding' => [
                    'branding-2961' => 'Branding'
                ]
            ],
            'inherit' => [
                
            ]
        ],
        'layout' => [
            'version' => 2,
            'preset' => [
                'image' => 'gantry-admin://images/layouts/offline.png',
                'name' => '_offline',
                'timestamp' => 1748586448
            ],
            'layout' => [
                '/header/' => [
                    0 => [
                        0 => 'logo-4995 30',
                        1 => 'spacer-5105 70'
                    ]
                ],
                '/main/' => [
                    0 => [
                        0 => 'system-messages-4931'
                    ],
                    1 => [
                        0 => 'system-content-9740'
                    ]
                ],
                '/footer/' => [
                    0 => [
                        0 => 'position-footer'
                    ],
                    1 => [
                        0 => 'copyright-5260 40',
                        1 => 'spacer-3323 30',
                        2 => 'branding-2961 30'
                    ]
                ]
            ],
            'structure' => [
                'header' => [
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
                'position-footer' => [
                    'attributes' => [
                        'key' => 'footer'
                    ]
                ]
            ]
        ]
    ]
];
