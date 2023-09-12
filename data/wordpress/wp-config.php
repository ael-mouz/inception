<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wpdb' );

/** Database username */
define( 'DB_USER', 'user' );

/** Database password */
define( 'DB_PASSWORD', 'password' );

/** Database hostname */
define( 'DB_HOST', 'mariadb' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

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
define( 'AUTH_KEY',          'm7ao8go|RPIK.FAFBBk1hFAPg`oX~p/6P(_hDC>=9PwqWDX2=-rMc(f|!ab ehmI' );
define( 'SECURE_AUTH_KEY',   'c1|&3g~@,d1!0ZDEib1^evj#kwwNhD=Kf`>JFPJ^E]zb}E%P_rRvjabSF]9/}%),' );
define( 'LOGGED_IN_KEY',     'au6][qyd+FOXf=q((f8aAEO?HS+_Qagj#[r:SHtFt3lZR_zAjvSj*]vRZUBB/`v=' );
define( 'NONCE_KEY',         'k!:(#S,J4UA=3ri0B<oIIb 40g]5+;+Eb)[=*l]UEC_xEy&)v@^NWY-U,aImB> H' );
define( 'AUTH_SALT',         '-a{.zASXCv~V$?mg1`4D/+d5W,Ov3|Z{C/}3Mw@K=O!5F#n.)*:g4?q5D,SId,7~' );
define( 'SECURE_AUTH_SALT',  '{D`_%Uqou}J<ROS sx%0;&iq2#=Qv.cNrD4|(>r!otTd94o]``I)N3AD)RymLpbG' );
define( 'LOGGED_IN_SALT',    '1-E^RO2u*k4MUcLHwur7pPlx T0mztpf0)EwV9}HB&H3R2$#fRv&22X&[20#c|fP' );
define( 'NONCE_SALT',        'IIle>@U6Rc,B[,i-O++1Wrx>JXNp/j CA&VrG`i7k>ix_FMNwR`9kJ{bHT!PLSl+' );
define( 'WP_CACHE_KEY_SALT', '7_/A?]6FEj:D3MHM;7bQl^!x`5EohM#B{ut(D>2iWLy+-|N{Hm~crg0zvmhzB(YY' );


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Add any custom values between this line and the "stop editing" line. */



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
if ( ! defined( 'WP_DEBUG' ) ) {
	define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
