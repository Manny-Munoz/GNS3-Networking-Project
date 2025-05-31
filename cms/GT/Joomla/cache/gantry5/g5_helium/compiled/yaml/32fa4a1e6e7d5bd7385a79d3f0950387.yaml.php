<?php
return [
    '@class' => 'Gantry\\Component\\File\\CompiledYamlFile',
    'filename' => 'C:\\xampp\\htdocs\\Joomla/templates/g5_helium/custom/config/13/layout.yaml',
    'modified' => 1748592007,
    'data' => [
        'version' => 2,
        'preset' => [
            'image' => 'gantry-admin://images/layouts/default.png',
            'name' => 'home_-_particles',
            'timestamp' => 1748540859
        ],
        'layout' => [
            'navigation' => [
                
            ],
            '/header/' => [
                0 => [
                    0 => 'owlcarousel-2455'
                ]
            ],
            '/intro/' => [
                0 => [
                    0 => 'custom-5807'
                ]
            ],
            '/features/' => [
                0 => [
                    0 => 'custom-3119'
                ]
            ],
            '/utility/' => [
                0 => [
                    0 => 'contenttabs-3854'
                ]
            ],
            '/above/' => [
                0 => [
                    0 => 'custom-4908'
                ]
            ],
            '/testimonials/' => [
                
            ],
            '/expanded/' => [
                
            ],
            '/container-main/' => [
                0 => [
                    0 => [
                        'mainbar 75' => [
                            
                        ]
                    ],
                    1 => [
                        'sidebar 25' => [
                            
                        ]
                    ]
                ]
            ],
            '/footer/' => [
                0 => [
                    0 => 'logo-8311 25',
                    1 => 'copyright-7136 45',
                    2 => 'totop-6550 30'
                ]
            ],
            'offcanvas' => [
                
            ]
        ],
        'structure' => [
            'navigation' => [
                'type' => 'section',
                'inherit' => [
                    'outline' => 'default',
                    'include' => [
                        0 => 'attributes',
                        1 => 'children'
                    ]
                ]
            ],
            'header' => [
                'attributes' => [
                    'boxed' => '',
                    'class' => 'g-flushed',
                    'variations' => ''
                ]
            ],
            'intro' => [
                'type' => 'section',
                'attributes' => [
                    'boxed' => ''
                ]
            ],
            'features' => [
                'type' => 'section',
                'attributes' => [
                    'boxed' => ''
                ]
            ],
            'utility' => [
                'type' => 'section',
                'attributes' => [
                    'boxed' => '',
                    'class' => ''
                ]
            ],
            'above' => [
                'type' => 'section',
                'attributes' => [
                    'boxed' => '1',
                    'class' => '',
                    'variations' => ''
                ]
            ],
            'testimonials' => [
                'type' => 'section',
                'attributes' => [
                    'boxed' => ''
                ]
            ],
            'expanded' => [
                'type' => 'section',
                'attributes' => [
                    'boxed' => '',
                    'class' => '',
                    'variations' => ''
                ]
            ],
            'mainbar' => [
                'type' => 'section',
                'subtype' => 'main'
            ],
            'sidebar' => [
                'type' => 'section',
                'subtype' => 'aside'
            ],
            'container-main' => [
                'attributes' => [
                    'boxed' => ''
                ]
            ],
            'footer' => [
                'attributes' => [
                    'boxed' => '',
                    'class' => '',
                    'variations' => ''
                ]
            ],
            'offcanvas' => [
                'inherit' => [
                    'outline' => 'default',
                    'include' => [
                        0 => 'attributes',
                        1 => 'children'
                    ]
                ]
            ]
        ],
        'content' => [
            'owlcarousel-2455' => [
                'title' => 'Owl Carousel',
                'attributes' => [
                    'nav' => 'enable',
                    'dots' => 'enable',
                    'autoplay' => 'enable',
                    'imageOverlay' => 'disable',
                    'items' => [
                        0 => [
                            'class' => '',
                            'image' => 'gantry-media://header/908D70E9-FA6E-44C4-B3F2-8281089B1B41.PNG',
                            'title' => '',
                            'desc' => '',
                            'link' => '',
                            'linktext' => '',
                            'buttonclass' => '',
                            'disable' => '0',
                            'name' => 'Item 1'
                        ],
                        1 => [
                            'class' => '',
                            'image' => 'gantry-media://header/05C563E2-742F-4F89-8A63-0B4EF7B7DF0D.PNG',
                            'title' => '',
                            'desc' => '',
                            'link' => '',
                            'linktext' => '',
                            'buttonclass' => '',
                            'disable' => '0',
                            'name' => 'Item 2'
                        ]
                    ]
                ]
            ],
            'custom-5807' => [
                'title' => 'Intro',
                'attributes' => [
                    'html' => '<div class="fp-intro">
    <h2 class="g-title">Adquiere tu nueva tablet con planes de financiamiento.</h2>
    <p>¡Porque el momento es ahora!</p>
    <div class="ipad-mockup">
        <img src="gantry-media://intro/mockup.png" alt="" />
    </div>
</div>'
                ],
                'block' => [
                    'variations' => 'center'
                ]
            ],
            'custom-3119' => [
                'title' => 'Features',
                'attributes' => [
                    'html' => '<div class="fp-features">
    <div class="g-grid">
        <div class="g-block size-33-3">
            <div class="card">
                <div class="card-block">
                    <i class="fa fa-credit-card"></i>
                    <h4 class="card-title">Paga tus facturas</h4>
                    <p class="card-text"> Paga tus facturas en línea desde la comodidad de tu hogar, o donde sea que te encuentres.</p>
                </div>
            </div>
        </div>
        <div class="g-block size-33-3">
            <div class="card">
                <div class="card-block">
                    <i class="fa fa-shopping-cart"></i>
                    <h4 class="card-title">Adquiere tu smartphone en línea</h4>
                    <p class="card-text">Accede a nuestra tienda para comprar tu nuevo dispositivo.</p>
                </div>
            </div>
        </div>
        <div class="g-block size-33-3">
            <div class="card">
                <div class="card-block">
                    <i class="fa fa-mobile"></i>
                    <h4 class="card-title">Contratación de servicios</h4>
                    <p class="card-text">Renueva tu plan o adquiere un nuevo plan y recibe un teléfono celular gratis.</p>
                </div>
            </div>
        </div>
    </div>
</div>'
                ],
                'block' => [
                    'variations' => 'center'
                ]
            ],
            'contenttabs-3854' => [
                'title' => 'Content Tabs',
                'attributes' => [
                    'items' => [
                        0 => [
                            'content' => '<p>Gantry 5 includes a new, powerful Menu editor that makes menu organization,
particle and module injection, and visual enhancements a breeze. Here are just
a handful of things you can do with Gantry 5’s powerful Menu Editor.</p>
<div class="g-grid size-100">
    <div class="g-block size-50">
        <ul>
            <li>
                FontAwesome Icons
            </li>
            <li>
                Easy Module Injection
            </li>
            <li>
                Simple Particle Injection
            </li>
            <li>
                Drag-and-drop Functionality
            </li>
            <li>
                Per-item CSS Classes
            </li>
            <li>
                Submenu Column Control
            </li>
        </ul>
    </div>
    <div class="g-block size-50">
        <ul>
            <li>
                Easy Organization / Reordering
            </li>
            <li>
                Link Target Designation
            </li>
            <li>
                Multiple Dropdown Styles
            </li>
            <li>
                Per-item Image Support
            </li>
            <li>
                Subtitles
            </li>
            <li>
                Non-destructive
            </li>
        </ul>
    </div>
</div>
<div class="g-grid">
    <div class="g-block size-100">
        Find out more about using the Menu Editor in our <a href="http://docs.gantry.org/gantry5/configure/menu-editor">documentation</a>.
    </div>
</div>',
                            'title' => 'Menu Editor'
                        ],
                        1 => [
                            'content' => '<p>The Layout Manager makes it easier than ever to arrange and customize your users’ experience with drag-and-drop simplicity from start to finish. A handful of the many features found in the Layout Manager are listed below.</p>
<div class="g-grid size-100">
    <div class="g-block size-50">
        <ul>
            <li>Drag-and-drop Functionality</li>
            <li>Unlimited Items Per Row</li>
            <li>Unlimited Rows Per Section</li>
            <li>Easy Widget Position Placement</li>
            <li>Resize Items with Simple Sliders</li>
            <li>Per-section CSS Classes and Tag Attributes</li>
        </ul>
    </div>
    <div class="g-block size-50">
        <ul>
            <li>Per-block CSS Classes, Variations, and Tag Attributes</li>
            <li>Quick Preset Loading</li>
            <li>Undo and Redo</li>
            <li>Access to Easy-to-use Particles</li>
            <li>Intuitive Visual Interface</li>
            <li>Touch-screen Friendly</li>
        </ul>
    </div>
</div>
<div>Find out more about using the Layout Manager in our <a href="http://docs.gantry.org/gantry5/configure/layout-manager">documentation</a>.</div>',
                            'title' => 'Layout Manager'
                        ]
                    ]
                ]
            ],
            'custom-4908' => [
                'title' => 'Custom HTML',
                'attributes' => [
                    'html' => '<div style="display: flex; flex-wrap: wrap; gap: 20px; justify-content: center;">
  <div style="flex: 0 0 calc(50% - 20px); text-align: center;">
    <img src="gantry-media://header/Captura de pantalla 2025-05-29 235500.PNG" alt="Imagen 1" style="max-width: 100%; height: auto;">
  </div>
  <div style="flex: 0 0 calc(50% - 20px); text-align: center;">
    <img src="gantry-media://header/v1.PNG" alt="Imagen 2" style="max-width: 100%; height: auto;">
  </div>
  <div style="flex: 0 0 calc(50% - 20px); text-align: center;">
    <img src="gantry-media://header/v2.PNG" alt="Imagen 3" style="max-width: 100%; height: auto;">
  </div>
  <div style="flex: 0 0 calc(50% - 20px); text-align: center;">
    <img src="gantry-media://header/v3.PNG" alt="Imagen 4" style="max-width: 100%; height: auto;">
  </div>
</div>'
                ]
            ],
            'logo-8311' => [
                'title' => 'Logo / Image',
                'attributes' => [
                    'target' => '_self',
                    'svg' => ''
                ],
                'inherit' => [
                    'outline' => 'default',
                    'particle' => 'logo-9571',
                    'include' => [
                        0 => 'block'
                    ]
                ]
            ],
            'copyright-7136' => [
                'inherit' => [
                    'outline' => 'default',
                    'include' => [
                        0 => 'attributes',
                        1 => 'block'
                    ],
                    'particle' => 'copyright-1736'
                ]
            ],
            'totop-6550' => [
                'title' => 'To Top',
                'inherit' => [
                    'outline' => 'default',
                    'include' => [
                        0 => 'attributes',
                        1 => 'block'
                    ],
                    'particle' => 'totop-8670'
                ]
            ]
        ]
    ]
];
