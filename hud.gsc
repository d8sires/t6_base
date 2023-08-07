open_menu() {
    self.menu.open       = true;
    self.recreate_option = true;
    self store_huds();
    self store_text( self.menu.current_title );
    self update_menu();
    self update_scroller();
    self.recreate_option = undefined;
}
close_menu() {
    option = array( "option_left", "option_right" );
    for( i = 0; i < option.size; i++ ) {
        if( isdefined( self.desires[ option[ i ] ] ) ) {
            for( x = 0; x < self.desires[ option[ i ] ].size; x++ ) {
                self.desires[ option[ i ] ][ x ] destroy();
            }
        }
    }
    self clear_menu( true );
    self.menu.open = undefined;
}

init_preload() {
    if( !isdefined( self.color_palette ) ) {
        self.color_palette = [];
        self.color_palette[ 0 ] = divide_color( 0, 0, 0 );          // black
        self.color_palette[ 1 ] = divide_color( 255, 255, 255 );    // white
        self.color_palette[ 2 ] = divide_color( 255, 0, 255 );      // gradient left
        self.color_palette[ 3 ] = divide_color( 255, 0, 13 );      // gradient right
    }
}

store_huds() {
    self.desires[ "aio" ][ "gradient_left" ]  = self shape( "TOP", "CENTER", 0, -234, 180, 24, self.color_palette[ 2 ], "white", 2, 1 );
    self.desires[ "aio" ][ "gradient_right" ] = self shape( "TOP", "CENTER", 0, -234, 180, 24, self.color_palette[ 3 ], "gradient_fadein", 3, 1 );
    self.desires[ "aio" ][ "header" ]         = self shape( "TOP", "CENTER", 0, -210, 180, 16, self.color_palette[ 0 ], "white", 4, 1 );
    self.desires[ "aio" ][ "background" ]     = self shape( "TOP", "CENTER", 0, -194, 180, 16, self.color_palette[ 0 ], "white", 5, .9 );
    if( !isdefined( self.scrollbar_cache ) ) {
        self.desires[ "aio" ][ "scrollbar" ]  = self shape( "TOP", "CENTER", 0, -194, 180, 16, self.color_palette[ 1 ], "white", 6, 1 );
    }
    else {
        self.desires[ "aio" ][ "scrollbar" ]  = self shape( "TOP", "CENTER", 0, self.scrollbar_cache, 180, 16, self.color_palette[ 1 ], "white", 6, 1 );
    }
    self.desires[ "aio" ][ "footer" ]         = self shape( "TOP", "CENTER", 0, -178, 180, 2, self.color_palette[ 0 ], "white", 7, 1 );
    self.desires[ "aio" ][ "up_arrow" ]       = self shape( "TOP", "CENTER", 0, -175, 3, 3, self.color_palette[ 1 ], "ui_scrollbar_arrow_up_a", 8, 0 );
    self.desires[ "aio" ][ "down_arrow" ]     = self shape( "TOP", "CENTER", 0, -168, 3, 3, self.color_palette[ 1 ], "ui_scrollbar_arrow_dwn_a", 9, 0 );
    self.desires[ "aio" ][ "title" ]          = self text( tolower( level.title ), "objective", 1.2, "CENTER", "TOP", 0, -19, self.color_palette[ 1 ], 1, 10, true );
    self.desires[ "aio" ][ "subtitle" ]       = self text( "", "objective", 1, "LEFT", "TOP", -84, 2, self.color_palette[ 1 ], 1, 10, true );
    self.desires[ "aio" ][ "counter" ]        = self text( "", "objective", 1, "RIGHT", "TOP", 84, 2, self.color_palette[ 1 ], 1, 10, true );
}
store_text( menu ) {
    if( !isdefined( menu ) ) {
        self.desires[ "aio" ][ "subtitle" ] stext( self.desires[ "menu" ] );
    }
    else {
        self.desires[ "aio" ][ "subtitle" ] stext( menu );
    }
    if( isdefined( self.recreate_option ) ) {
        for( a = 0; a < 5; a++ ) {
            self.desires[ "option_left" ][ a ] = self text( "", "objective", 1, "LEFT", "TOP", -84, ( ( a * 16 ) + 18 ), self.color_palette[ 1 ], 1, 10, true );
            self.desires[ "option_right" ][ a ] = self shape( "RIGHT", "TOP", 84, ( ( a * 16 ) + 18 ), 5, 5, self.color_palette[ 1 ], "white", 10, 1 );
        }
    }
}
update_text() {
    foreach( hud in array( "title", "counter" ) ) {
        if( isdefined( self.desires[ "aio" ][ hud ] ) )
            self.desires[ "aio" ][ hud ] destroy();
    }
    self.desires[ "aio" ][ "title" ] = self text( tolower( level.title ), "objective", 1.2, "CENTER", "TOP", 0, -19, self.color_palette[ 1 ], 1, 10, true );
    self.desires[ "aio" ][ "counter" ] = self text( "", "objective", 1, "RIGHT", "TOP", 84, 2, self.color_palette[ 1 ], 1, 10, true );
    self resize_huds();
    self update_utilities();
}
update_utilities() {
    if( isdefined( self.menu.option[ self.menu.current_menu ][ self.menu.cursor[ self.menu.current_menu ] ] ) )
        self.desires[ "aio" ][ "counter" ] stext( "[" + ( self.menu.cursor[ self.menu.current_menu ] + 1 ) + "/" + self.menu.option[ self.menu.current_menu ].size + "]" );
    else
        self.desires[ "aio" ][ "counter" ] stext( "[0/0]" );
}

update_scroller() {
    if( self.menu.cursor[ self.menu.current_menu ] < 0 ) {
        self.menu.cursor[ self.menu.current_menu ] = self.menu.option[ self.menu.current_menu ].size - 1;
    }
    if( self.menu.cursor[ self.menu.current_menu ] > self.menu.option[ self.menu.current_menu ].size - 1 ) {
        self.menu.cursor[ self.menu.current_menu ] = 0;
    }
    if( !isdefined( self.menu.option[ self.menu.current_menu ][ self.menu.cursor[ self.menu.current_menu ] - 2 ] ) || self.menu.option[ self.menu.current_menu ].size <= 5 ) {
        menu   = self get_menu();
        cursor = self get_cursor();
        for( a = 0; a < 5; a++ ) {
            if( isdefined( self.menu.option[ menu ][ a ] ) ) {
                self.desires[ "option_left" ][ a ] stext( self.menu.option[ menu ][ a ] );
            }
            else {
                self.desires[ "option_left" ][ a ] stext( "" );
            }
            if( cursor == a ) {
                foreach( hud in array( "option_left", "option_right" ) ) {
                    if( self.menu.option[ menu ].size <= 1 ) {
                        self.desires[ hud ][ a ].color = self.color_palette[ 1 ];
                    }
                    else {
                        self.desires[ hud ][ a ].color = self.color_palette[ 0 ];
                    }
                }
            }
            else {
                foreach( hud in array( "option_left", "option_right" ) ) {
                    if( self.menu.option[ menu ].size <= 1 ) {
                        self.desires[ hud ][ a ].color = self.color_palette[ 0 ];
                    }
                    else {
                        self.desires[ hud ][ a ].color = self.color_palette[ 1 ];
                    }
                }
            }
            if( isdefined( self.menu.toggle[ menu ][ a ] ) ) {
                self.desires[ "option_right" ][ a ] setpoint( "RIGHT", "TOP", 84, ( ( a * 16 ) + 18 ) );
                self.desires[ "option_right" ][ a ].color = divide_color( 255, 255, 255 );
                if( self.menu.toggle[ menu ][ a ] == true ) {
                    self.desires[ "option_right" ][ a ] setshader( "menu_mp_killstreak_select", 5, 5 );
                }
                else {
                    self.desires[ "option_right" ][ a ] setshader( "menu_mp_contract_expired", 5, 5 );
                }
            }
            else {
                if( isdefined( self.menu.function[ menu ][ a ] ) && self.menu.function[ menu ][ a ] == ::new_menu ) {
                    self.desires[ "option_right" ][ a ] setpoint( "RIGHT", "TOP", 84, ( ( a * 16 ) + 19 ) );
                    if( cursor == a ) {
                        self.desires[ "option_right" ][ a ] setshader( "ui_arrow_right", 5, 5 );
                    }
                    else {
                        self.desires[ "option_right" ][ a ] setshader( "ui_arrow_left", 5, 5 );
                    }
                }
                else if( isdefined( self.menu.shader[ menu ][ a ] ) ) {
                    self.desires[ "option_right" ][ a ] setpoint( "CENTER", "TOP", 0, ( ( a * 16 ) + 18 ) );
                    self.desires[ "option_right" ][ a ].color = self.menu.input_b[ menu ][ a ];
                    self.desires[ "option_right" ][ a ] setshader( self.menu.shader[ menu ][ a ], self.menu.input_c[ menu ][ a ], self.menu.input_d[ menu ][ a ] );
                }
                else if( isdefined( self.menu.slider_cursor[ menu + "_cursor" ][ a ] ) ) {
                    self.desires[ "option_right" ][ a ] setpoint( "RIGHT", "TOP", 84, ( ( a * 16 ) + 18 ) );
                    self.desires[ "option_right" ][ a ] stext(  "< " + self.menu.slider[ menu ][ "slider" ][ a ] + " > [" + ( self.menu.slider_cursor[ menu + "_cursor" ][ a ] + 1 ) + "/" + self.menu.slider[ menu ][ "array" ][ a ].size + "]" );
                }
                else {
                    self.desires[ "option_right" ][ a ] stext( "" );
                }
            }
        }
        self.scrollbar_cache = ( ( 16 * cursor ) + -194 );
        self.desires[ "aio" ][ "scrollbar" ].y = ( ( 16 * cursor ) + -194 );
    }
    else {
        if( isdefined( self.menu.option[ self.menu.current_menu ][ self.menu.cursor[ self.menu.current_menu ] + 2 ] ) ) {
            xepixtvx = 0;
            menu     = self get_menu();
            cursor   = self get_cursor();
            for( a = cursor - 2; a < cursor + 3; a++ ) {
                if( isdefined( self.menu.option[ menu ][ a ] ) ) {
                    self.desires[ "option_left" ][ xepixtvx ] stext( self.menu.option[ menu ][ a ] );
                }
                else {
                    self.desires[ "option_left" ][ xepixtvx ] stext( "" );
                }
                if( cursor == a ) {
                    foreach( hud in array( "option_left", "option_right" ) ) {
                        if( self.menu.option[ menu ].size <= 1 ) {
                            self.desires[ hud ][ xepixtvx ].color = self.color_palette[ 1 ];
                        }
                        else {
                            self.desires[ hud ][ xepixtvx ].color = self.color_palette[ 0 ];
                        }
                    }
                }
                else {
                    foreach( hud in array( "option_left", "option_right" ) ) {
                        if( self.menu.option[ menu ].size <= 1 ) {
                            self.desires[ hud ][ xepixtvx ].color = self.color_palette[ 0 ];
                        }
                        else {
                            self.desires[ hud ][ xepixtvx ].color = self.color_palette[ 1 ];
                        }
                    }
                }
                if( isdefined( self.menu.toggle[ menu ][ a ] ) ) {
                    self.desires[ "option_right" ][ xepixtvx ] setpoint( "RIGHT", "TOP", 84, ( ( xepixtvx * 16 ) + 18 ) );
                    self.desires[ "option_right" ][ xepixtvx ].color = divide_color( 255, 255, 255 );
                    if( self.menu.toggle[ menu ][ a ] == true ) {
                        self.desires[ "option_right" ][ xepixtvx ] setshader( "menu_mp_killstreak_select", 5, 5 );
                    }
                    else {
                        self.desires[ "option_right" ][ xepixtvx ] setshader( "menu_mp_contract_expired", 5, 5 );
                    }
                }
                else {
                    if( isdefined( self.menu.function[ menu ][ a ] ) && self.menu.function[ menu ][ a ] == ::new_menu ) {
                        self.desires[ "option_right" ][ xepixtvx ] setpoint( "RIGHT", "TOP", 84, ( ( xepixtvx * 16 ) + 19 ) );
                        if( self.menu.cursor[ menu ] == a ) {
                            self.desires[ "option_right" ][ xepixtvx ] setshader( "ui_arrow_right", 5, 5 );
                        }
                        else {
                            self.desires[ "option_right" ][ xepixtvx ] setshader( "ui_arrow_left", 5, 5 );
                        }
                    }
                    else if( isdefined( self.menu.shader[ menu ][ a ] ) ) {
                        self.desires[ "option_right" ][ xepixtvx ] setpoint( "CENTER", "TOP", 0, ( ( xepixtvx * 16 ) + 18 ) );
                        self.desires[ "option_right" ][ xepixtvx ].color = self.menu.input_b[ menu ][ a ];
                        self.desires[ "option_right" ][ xepixtvx ] setshader( self.menu.shader[ menu ][ a ], self.menu.input_c[ menu ][ a ], self.menu.input_d[ menu ][ a ] );
                    }
                    else if( isdefined( self.menu.slider_cursor[ menu + "_cursor" ][ a ] ) ) {
                        self.desires[ "option_right" ][ xepixtvx ] setpoint( "RIGHT", "TOP", 84, ( ( xepixtvx * 16 ) + 18 ) );
                        self.desires[ "option_right" ][ xepixtvx ] stext( "< " + self.menu.slider[ menu ][ "slider" ][ a ] + " > [" + ( self.menu.slider_cursor[ menu + "_cursor" ][ a ] + 1 ) + "/" + self.menu.slider[ menu ][ "array" ][ a ].size + "]" );
                    }
                    else {
                        self.desires[ "option_right" ][ xepixtvx ] stext( "" );
                    }
                }
                xepixtvx++;
            }
            self.scrollbar_cache = ( ( 16 * 2 ) + -194 );
            self.desires[ "aio" ][ "scrollbar" ].y = ( ( 16 * 2 ) + -194 );
        }
        else {
            menu   = self get_menu();
            cursor = self get_cursor();
            for( a = 0; a < 5; a++ ) {
                self.desires[ "option_left" ][ a ] stext( self.menu.option[ menu ][ self.menu.option[ menu ].size + ( a - 5 ) ] );
                if( cursor == self.menu.option[ menu ].size + ( a - 5 ) ) {
                    foreach( hud in array( "option_left", "option_right" ) ) {
                        if( self.menu.option[ menu ].size <= 1 ) {
                            self.desires[ hud ][ a ].color = self.color_palette[ 1 ];
                        }
                        else {
                            self.desires[ hud ][ a ].color = self.color_palette[ 0 ];
                        }
                    }
                }
                else {
                    foreach( hud in array( "option_left", "option_right" ) ) {
                        if( self.menu.option[ menu ].size <= 1 ) {
                            self.desires[ hud ][ a ].color = self.color_palette[ 0 ];
                        }
                        else {
                            self.desires[ hud ][ a ].color = self.color_palette[ 1 ];
                        }
                    }
                }
                if( isdefined( self.menu.toggle[ menu ][ self.menu.option[ menu ].size + ( a - 5 ) ] ) ) {
                    self.desires[ "option_right" ][ a ] setpoint( "RIGHT", "TOP", 84, ( ( a * 16 ) + 18 ) );
                    self.desires[ "option_right" ][ a ].color = divide_color( 255, 255, 255 );
                    if( self.menu.toggle[ menu ][ self.menu.option[ menu ].size + ( a - 5 ) ] == true ) {
                        self.desires[ "option_right" ][ a ] setshader( "menu_mp_killstreak_select", 5, 5 );
                    }
                    else {
                        self.desires[ "option_right" ][ a ] setshader( "menu_mp_contract_expired", 5, 5 );
                    }
                }
                else {
                    if( isdefined( self.menu.function[ menu ][ self.menu.option[ menu ].size + ( a - 5 ) ] ) && self.menu.function[ menu ][ self.menu.option[ menu ].size + ( a - 5 ) ] == ::new_menu ) {
                        self.desires[ "option_right" ][ a ] setpoint( "RIGHT", "TOP", 84, ( ( a * 16 ) + 19 ) );
                        if( cursor == self.menu.option[ menu ].size + ( a - 5 ) ) {
                            self.desires[ "option_right" ][ a ] setshader( "ui_arrow_right", 5, 5 );
                        }
                        else {
                            self.desires[ "option_right" ][ a ] setshader( "ui_arrow_left", 5, 5 );
                        }
                    }
                    else if( isdefined( self.menu.shader[ menu ][ self.menu.option[ menu ].size + ( a - 5 ) ] ) ) {
                        option = ( self get_option().size + ( a - 5 ) );
                        self.desires[ "option_right" ][ a ] setpoint( "CENTER", "TOP", 0, ( ( a * 16 ) + 18 ) );
                        self.desires[ "option_right" ][ a ].color = self.menu.input_b[ menu ][ option ];
                        self.desires[ "option_right" ][ a ] setshader( self.menu.shader[ menu ][ option ], self.menu.input_c[ menu ][ option ], self.menu.input_d[ menu ][ option ] );
                    }
                    else if( isdefined( self.menu.slider[ menu ][ "slider" ][ self.menu.option[ menu ].size + ( a - 5 ) ] ) ) {
                        self.desires[ "option_right" ][ a ] setpoint( "RIGHT", "TOP", 84, ( ( a * 16 ) + 18 ) );
                        self.desires[ "option_right" ][ a ] stext( "< " + self.menu.slider[ menu ][ "slider" ][ self.menu.option[ menu ].size + ( a - 5 ) ] + " > [" + ( self.menu.slider_cursor[ menu + "_cursor" ][ self.menu.option[ menu ].size + ( a - 5 ) ] + 1 ) + "/" + self.menu.slider[ menu ][ "array" ][ self.menu.option[ menu ].size + ( a - 5 ) ].size + "]" );
                    }
                    else {
                        self.desires[ "option_right" ][ a ] stext( "" );
                    }
                }
            }
            self.scrollbar_cache = ( 16 * ( ( cursor - self.menu.option[ menu ].size ) + 5 ) + -194 );

            self.desires[ "aio" ][ "scrollbar" ].y = -194 + (16* ( ( cursor - self.menu.option[ menu ].size ) + 5));
            //when the y value is being changed to move HUDs, make sure to change -50
        }
    }
}
resize_huds() {
    size = self.menu.option[ self.menu.current_menu ].size;
    foreach( shader in array( "up_arrow", "down_arrow" ) ) {
        self.desires[ "aio" ][ shader ].alpha = 0;
    }
    if( size <= 5 ) {
        if( size <= 0 ) {
            self store_text( "Currently No Options To Display!" );
            foreach( shader in array( "background", "scrollbar", "counter", "footer" ) ) {
                self.desires[ "aio" ][ shader ].alpha = 0;
            }
        }
        else {
            if( size >= 0 ) {
                foreach( shader in array( "counter", "footer" ) ) {
                    self.desires[ "aio" ][ shader ].alpha = 1;
                }
                self.desires[ "aio" ][ "background" ].alpha = .9;
                if( size == 1 ) {
                    self.desires[ "aio" ][ "scrollbar" ].alpha = 0;
                }
                else {
                    self.desires[ "aio" ][ "scrollbar" ].alpha = 1;
                }
            }
        }
        self.desires[ "aio" ][ "footer" ] setshader( "white", 180, 2 );
    }
    else {
        size = 5;
        foreach( shader in array( "scrollbar", "counter", "footer", "up_arrow", "down_arrow" ) ) {
            self.desires[ "aio" ][ shader ].alpha = 1;
        }
        self.desires[ "aio" ][ "background" ].alpha = .9;
        self.desires[ "aio" ][ "footer" ] setshader( "white", 180, 16 );
    }
    self.desires[ "aio" ][ "background" ] setshader( "white", 180, ( size * 16 ) );
    self.desires[ "aio" ][ "footer" ].y = ( ( size * 16 ) - 194 );
    self.desires[ "aio" ][ "up_arrow" ].y = ( ( size * 16 ) -191 );
    self.desires[ "aio" ][ "down_arrow" ].y = ( ( size * 16 ) -184 );
}