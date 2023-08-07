text( text, font, scale, align, relative, x, y, color, alpha, sort, server, number ) {
    if( isdefined( server ) ) {
        textelem = level createserverfontstring( font, scale );
    }
    else {
        textelem = self createfontstring( font, scale );
    }
    textelem setpoint( align, relative, x, y );
    textelem.color          = color;
    textelem.alpha          = alpha;
    textelem.sort           = sort;
    textelem.hidewheninmenu = true;
    textelem.foreground     = true;
    textelem.archived       = true;
    if( isdefined( text ) ) {
        if( !isdefined( number ) ) {
            textelem stext( text );
        }
        else {
            textelem setvalue( text );
        }
    }
    return textelem;
}
shape( align, relative, x, y, width, height, color, shader, sort, alpha, server ) {
    if( isdefined( server ) ) {
        boxelem = newhudelem();
    }
    else {
        boxelem = newclienthudelem( self );
    }
    boxelem.elemtype = "icon";
    boxelem.children = [];
    boxelem setparent( level.uiparent );
    boxelem setpoint( align, relative, x, y );
    boxelem setshader( shader, width, height );
    boxelem.color          = color;
    boxelem.sort           = sort;
    boxelem.alpha          = alpha;
    boxelem.hidewheninmenu = true;
    boxelem.foreground     = true;
    boxelem.archived       = true;
    return boxelem;
}
bool( bool ) {
    if( isdefined( bool ) && bool ) {
        return true;
    }
    return false;
}
return_bool( bool ) {
    return ( !isdefined( bool ) ? true : undefined );
}
bool_state( bool ) {
    return ( isdefined( bool ) && isalive( self ) );
}
get_menu() {
    return self.menu.current_menu;
}
get_cursor() {
    return self.menu.cursor[ self.menu.current_menu ];
}
set_menu( menu ) {
    self.menu.current_menu = menu;
}
set_cursor( cursor ) {
    self.menu.cursor[ self.menu.current_menu ] = cursor;
}
get_option() {
    return self.menu.option[ self.menu.current_menu ];
}
get_function() {
    return self.menu.function[ self.menu.current_menu ];
}
get_argument_a() {
    return self.menu.input_a[ self.menu.current_menu ];
}
get_argument_b() {
    return self.menu.input_b[ self.menu.current_menu ];
}
get_argument_c() {
    return self.menu.input_c[ self.menu.current_menu ];
}
get_argument_d() {
    return self.menu.input_d[ self.menu.current_menu ];
}
get_argument_e() {
    return self.menu.input_e[ self.menu.current_menu ];
}
get_shader() {
    return self.menu.shader[ self.menu.current_menu ];
}
get_player( player ) {
    client = getsubstr( player.name, 0, player.name.size );
    for( i = 0; i < client.size; i++ )
        if( client[ i ] == "]" )
            break;
    if( client.size != i )
        client = getsubstr( client, i + 1, client.size );
    return client;
}

in_menu() {
    if( isdefined( self.menu_access ) && isdefined( self.menu.open ) ) {
        return true;
    }
    return false;
}
divide_color( r, g, b ) {
    return ( r / 255, g / 255, b / 255 );
}
change_color( element, color ) {
    if( element == "gradient_left" ) {
        self.color_palette[ 2 ] = color;
    }
    if( element == "gradient_right" ) {
        self.color_palette[ 3 ] = color;
    }
    self.desires[ "aio" ][ element ] fadeovertime( .2 );
    self.desires[ "aio" ][ element ].color = color;
    wait .125;
}
stext( text ) {
    if( !isinarray( level.strings, text ) ) {
        level.strings[ level.strings.size ] = text;
        self settext( text );
        if( level.strings.size >= 60 ) {
            level notify( "clear_strings" );
        }
    }
    else {
        self settext( text );
    }
}
overflowfix() {
    level endon( "end_game" );
    level endon( "host_migration_begin" );
    test       = level createserverfontstring( "objective", 1 );
    test.alpha = 0;
    test settext( "xtul" );
    while( true ) {
        level waittill( "clear_strings" );
        test clearalltextafterhudelem();
        level.strings = [];
    }
}

get_access() {
    if( self.access == "Dev" || self.access == "Co-Host" || self.access == "Mod" || self.access == "VIP" || self.access == "Access" ) {
        return true;
    }
    return false;
}

getPlayerName(player)
{
    playerName = getSubStr(player.name, 0, player.name.size);
    for(i=0; i < playerName.size; i++)
    {
        if(playerName[i] == "]")
            break;
    }
    if(playerName.size != i)
        playerName = getSubStr(playerName, i + 1, playerName.size);
    return playerName;
}