<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wordpress_user' );

/** MySQL database password */
define( 'DB_PASSWORD', 'password' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '8u_}zdL_=eeJ]+/p%N^lT~,T~XkV:u,b)CAD*_}]U9imShY`uhb.W, ,DaV_~fXM');
define('SECURE_AUTH_KEY',  'mxUR@_hF=GkdyBBh2<+;>{d^0P.-#S@&0POAXHr!0Q FmM3CMe@x#aRA15L^_TRO');
define('LOGGED_IN_KEY',    'ME|eiBd9W^4Oi=i1El$vKed+/bqFTr6-J9t>PB*R<6VzHbMnN~dDO72l],x]_HRC');
define('NONCE_KEY',        'Z,=.ZX&oMXSui+-itoShZVHq{~|O10H92b|1:Y!@A$+gDPiwybZj%`J@3Z+l~(}W');
define('AUTH_SALT',        'ZirXr3hDU@r8%FT@w?eb,a2{~~fIG<W?B fOy!JWk[)[BlF}Q4p7S{QxVT}-dxKY');
define('SECURE_AUTH_SALT', '8jImw}+SQ#|%dW>cfa({,FEk6,QI#wh4n2n-Uj-_2Ht,!A^?rJ*0@=j]DcA{e>vR');
define('LOGGED_IN_SALT',   '+7&^^FWA4+l-A=#3(gAad:Ybb[?se*OR^p%+cH>+{YKKq(F;=fN&D+S3/Qx:M?9I');
define('NONCE_SALT',       '@GG%k0FDjo]a_Y4a9rIp=~s[R*Cw:W-f{=[DY,jE`.`,;/Vu17Qc_u1CPNQ4/qak');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
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
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* The other change we need to make is to set the method that WordPress should use to write to the filesystem. Since we’ve given the web server permission to write where it needs to, we can explicitly set the filesystem method to “direct” */
define('FS_METHOD', 'direct');

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
