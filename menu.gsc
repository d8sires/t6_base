menu_option() 
{
    if( self get_access() ) {
        main = self.desires[ "menu" ];
        self menu( main, undefined );

        a1 = "Sub Menu 1";
        self option(main, "Sub Menu 1", ::new_menu, a1, "Sub Menu 1");
        self menu(a1, main, "Sub Menu 1");
            self option(a1, "Placeholder", ::placeholder);
            self option(a1, "Placeholder", ::placeholder);


        if( self ishost() ) {
            option( main, "Player Options", ::new_menu, "player_menu", "Player Options" );
            menu( "player_menu", main, "Player Options" );
            for( a = 0; a < level.players.size; a++ )
                menu( "popt " + a, "player_menu", "" );
        }
    }
}

player_option() {
    self.menu.count[ "player_menu" ] = 0;
    for( a = 0; a < level.players.size; a++ ) {
        player     = level.players[ a ];
        user       = get_player( player );
        fixed_size = level.players.size -1;
        if( self.menu.cursor[ "player_menu" ] > fixed_size ) {
            self.menu.scroller[ "player_menu" ] = fixed_size;
            self.menu.cursor[ "player_menu" ] = fixed_size;
        }
        option( "player_menu", "[" + player.access + "]" + user, ::new_menu, "popt " + a, user );
        menu( "popt " + a, "player_menu", user );
            option( "popt " + a, "Teleport Him -> Me", ::teletome, player);
            option( "popt " + a, "Teleport Me -> Him", ::teletohim, player);
    }
}