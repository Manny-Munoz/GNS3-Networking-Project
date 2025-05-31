<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress_us' );

/** Database username */
define( 'DB_USER', 'root' );

/** Database password */
define( 'DB_PASSWORD', '' );

/** Database hostname */
define( 'DB_HOST', 'localhost' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '7~o/t3V!|n1z.eleq^o;RX(4/JA83rC7ghbY-c+JvBuQwz_BXRm[/UubfEq1=I${' );
define( 'SECURE_AUTH_KEY',  'p_^t:LL4[H2>D(|WJ1UF=HH +?#%&3dg]J,4WE#f[IZ[C+2tvQrK:7X<B~UCZ]Vd' );
define( 'LOGGED_IN_KEY',    'WKv.EEx5[ph,?cRpfozQtB,k8i/L3tH:@{F6=yZ)@S9eE.1Xl=d>;,%DtSOg~@*H' );
define( 'NONCE_KEY',        '6^I&sM7MPeN8yP<F}MTWU7a3fsKB*S9FEWiB`}G]zy 17e5KVV@CVQ.X!X1+B^%r' );
define( 'AUTH_SALT',        ']C3iwCFsktFo*>*[[<$4PWXoRjfL%?*90v@/*ALr.Do4}%-l!A|jC*6vWM]!QVg ' );
define( 'SECURE_AUTH_SALT', '[+kR=wyr_$p5l3:u2{(t,b6=C9<M@F-o@WM0c[6Q4d^} E.z@w&YM+zX#:1EWFNP' );
define( 'LOGGED_IN_SALT',   '!vbd_p3pQU5NPv%BtVm;;XgdD`CjBIV&{/Z5J!1Y|xaKb/SeHggH+P7b!Kk4zE7S' );
define( 'NONCE_SALT',       'jKm)_Iy%lgd1XGF[E&Dqx;@=2OA:vh%/&uN_n2~G@vB`(G~v^cttu%{qI0Ns .AC' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
