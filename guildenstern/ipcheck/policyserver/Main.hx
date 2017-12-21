import haxe.io.Bytes;
//import neko.vm.Thread;
import neko.net.Socket;

typedef Client = {
        var host : String;
        //var socket : neko.net.Socket;
        var socket : Socket;
}

/**
        Flash-policy-server.
        http://www.adobe.com/devnet/flashplayer/articles/socket_policy_files.html
*/
class Main extends neko.net.ThreadServer<Client,String> {

        static var policyFile : String;

        static function main() {

                var args = neko.Sys.args();
                var host : String;
                var port : Int;
                var filepath : String;
                if( args[0] == null || args[1]== null ) {
                        //neko.Lib.println( "Usage: neko flashpolicyd.n [host] [port] [file]" );
                        //neko.Lib.println( "Aborted." );
                        //return;
                        host = "what-is-my-ip-address.anonymous-proxy-servers.net";
                        //host = "78.129.167.165";
                        port = 843;
                        filepath = "/var/www/anontest/crossdomain.xml";
                } else {
                        host = args[0];
                        port = Std.parseInt( args[1] );
                        filepath = args[2];
                }

                policyFile = null;
                try {
                        policyFile = neko.io.File.getContent( filepath );
                } catch( e : Dynamic ) {
                        neko.Lib.println( "Cannot find policy find: " + filepath );
                        return;
                }

                var r : EReg = ~/cross-domain-policy/;
                if( !r.match( policyFile ) ) {
                        neko.Lib.println( "Invalid policy file: " + filepath );
                        return;
                }

                var server = new Main();
                neko.Lib.println( "Starting flash-policy server on port " + port);
                server.run( host, port );

        }

        override function clientConnected( s : Socket ) : Client {
                var host = s.peer().host.toString();
                logToFile( host, "Client connected" );
                return { host:host, socket:s };
        }

        override function clientDisconnected( c : Client ) {
                logToFile( c.host, "Client disconnected" );
        }

        override function readClientMessage( c : Client, buf : Bytes, pos : Int, len : Int ) {
                var complete = false;
                var cpos = pos;
                while( cpos < ( pos + len ) && !complete ) {
                        complete = ( buf.get( cpos ) == 0 );
                        cpos++;
                }
                if( !complete ) return null;
                var msg = buf.readString( pos, cpos - pos );
                return { msg : msg, bytes : cpos-pos };
        }

        override function clientMessage( c : Client, msg : String ) {
                var ereg = ~/policy-file-request/;
                if( !ereg.match( msg ) ) {
                        c.socket.write( "" );
                        //c.socket.close();
                        logToFile( c.host, "No policy request" + msg);
                } else {
                c.socket.write( policyFile );
                c.socket.output.writeByte( 0 );
                logToFile( c.host, "Sending policy" );
                //c.socket.close();
                }
        }

        function logToFile( ip : String, msg : String) {
                var log = neko.io.File.append("/var/www/policyserver/fpd.log", false);
                var d = Date.now();
                var i = ip.split(".");
                log.writeString( "" + Date.fromTime(d.getTime()) + "\t" + i[0] + "." + i[1] +".0.0\t" + msg + "\n");
                log.close();
        }

}
