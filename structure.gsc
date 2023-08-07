menu( menu, previous, title ) {
    self.menu.get[ menu ]      = menu;
    self.menu.count[ menu ]    = 0;
    self.menu.cursor[ menu ]   = 0;
    self.menu.scroller[ menu ] = 0;
    self.menu.slider[ menu ]   = [];
    self.menu.previous[ menu ] = previous;
    self.menu.title[ menu ]    = title;
}
new_menu( menu ) {
    if( !isdefined( menu ) ) {
        menu = self.menu.previous[ self.menu.previous.size -1 ];
        self.menu.previous[ self.menu.previous.size -1 ] = undefined;
    }
    else {
        self.menu.previous[ self.menu.previous.size ] = self get_menu();
    }
    if( menu == "player_menu" )
        player_option();
    self set_menu( menu );
    self store_text( self.menu.title[ menu ] );
    self update_utilities();
    self update_text();
    self update_scroller();
}
option( menu, text, function, a, b, c, d, e ) {
    menu                                 = self.menu.get[ menu ];
    number                               = self.menu.count[ menu ];
    self.menu.option[ menu ][ number ]   = text;
    self.menu.function[ menu ][ number ] = function;
    self.menu.input_a[ menu ][ number ]  = a;
    self.menu.input_b[ menu ][ number ]  = b;
    self.menu.input_c[ menu ][ number ]  = c;
    self.menu.input_d[ menu ][ number ]  = d;
    self.menu.input_e[ menu ][ number ]  = e;
    self.menu.count[ menu ]++;
}
toggle( menu, text, function, toggle, a, b, c, d, e ) {
    menu                                   = self.menu.get[ menu ];
    number                                 = self.menu.count[ menu ];
    self.menu.option[ menu ][ number ]     = text;
    self.menu.function[ menu ][ number ]   = function;
    if( isdefined( toggle ) ) {
        self.menu.toggle[ menu ][ number ] = toggle;
    }
    else {
        self.menu.toggle[ menu ][ number ] = undefined;
    }
    self.menu.input_a[ menu ][ number ]    = a;
    self.menu.input_b[ menu ][ number ]    = b;
    self.menu.input_c[ menu ][ number ]    = c;
    self.menu.input_d[ menu ][ number ]    = d;
    self.menu.input_e[ menu ][ number ]    = e;
    self.menu.count[ menu ]++;
}
slider( menu, text, function, ary, a, b, c, d, e ) {
    menu                                                      = self.menu.get[ menu ];
    number                                                    = self.menu.count[ menu ];
    self.menu.option[ menu ][ number ]                        = text;
    self.menu.function[ menu ][ number ]                      = function;
    if( !isdefined( self.menu.slider_cursor[ menu + "_cursor" ][ number ] ) ) {
        self.menu.slider_cursor[ menu + "_cursor" ][ number ] = 0;
    }
    self.menu.slider[ menu ][ "array" ][ number ]             = ary;
    self.menu.slider[ menu ][ "slider" ][ number ]            = self.menu.slider[ menu ][ "array" ][ number ][ self.menu.slider_cursor[ menu + "_cursor" ][ number ] ];
    self.menu.menu_array[ menu ][ number ]                    = "";
    self.menu.input_a[ menu ][ number ]                       = a;
    self.menu.input_b[ menu ][ number ]                       = b;
    self.menu.input_c[ menu ][ number ]                       = c;
    self.menu.input_d[ menu ][ number ]                       = d;
    self.menu.input_e[ menu ][ number ]                       = e;
    self.menu.count[ menu ]++;
}
shader( menu, text, function, shader, a, b, c, d, e ) {
    menu                                   = self.menu.get[ menu ];
    number                                 = self.menu.count[ menu ];
    self.menu.option[ menu ][ number ]     = text;
    self.menu.function[ menu ][ number ]   = function;
    if( isdefined( shader ) ) {
        self.menu.shader[ menu ][ number ] = shader;
    }
    self.menu.input_a[ menu ][ number ]    = a;
    self.menu.input_b[ menu ][ number ]    = b;
    self.menu.input_c[ menu ][ number ]    = c;
    self.menu.input_d[ menu ][ number ]    = d;
    self.menu.input_e[ menu ][ number ]    = e;
    self.menu.count[ menu ]++;
}
update_toggle( toggle, menu, cursor ) {
    if( !isdefined( menu ) ) {
        menu = self get_menu();
    }
    if( !isdefined( cursor ) ) {
        cursor = self get_cursor();
    }
    self.menu.toggle[ menu ][ cursor ] = toggle;
    self update_menu();
}
update_slider( slider, menu, cursor ) {
    self notify( "slider_update" );
    if( !isdefined( menu ) ) {
        menu = self get_menu();
    }
    if( !isdefined( cursor ) ) {
        cursor = self get_cursor();
    }
    self.menu.menu_array[ menu ][ cursor ] = slider;
    self thread update_scroller();
}
update_menu() {
    saved_cursor = [];
    foreach( key in getarraykeys( self.menu.cursor ) ) {
        saved_cursor[ key ] = self.menu.cursor[ key ];
    }
    self menu_option();
    foreach( key in getarraykeys( saved_cursor ) ) {
        self.menu.cursor[ key ] = saved_cursor[ key ];
    }
    if( self in_menu() ) {
        self update_text();
        self update_scroller();
    }
}
clear_all( menu_array ) {
    keys = getarraykeys( menu_array );
    for( i = 0; i < keys.size; i++ ) {
        if( isdefined( menu_array[ keys[ i ] ][ 0 ] ) ) {
            for( b = 0; b < menu_array[ keys[ i ] ].size; b++ ) {
                menu_array[ keys[ i ] ][ b ] destroy();
            }
        }
        else {
            menu_array[ keys[ i ] ] destroy();
        }
    }
}
clear_menu( all ) {
    if( isdefined( all ) ) {
        foreach( hud in array( "aio", "option_left", "option_right" ) ) {
            if( isdefined( self.desires[ hud ] ) ) {
                self clear_all( self.desires[ hud ] );
            }
        }
    }
}