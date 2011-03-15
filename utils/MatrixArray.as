package undolibrary.utils {
	/**
	 * Gestisce una matrice N x M in un array lineare aggiungedo speciali
	 * proprietà e metodi per eseguire funzioni di flip, clip e move.
	 *
	 * @author		Giovambattista Fazioli
	 * @email		g.fazioli@undolog.com
	 * @web			http://www.undolog.com
	 * @version		1.1.0
	 *
	 * @note
	 *	In questa versione ho dovuto ricorrere a vari stratagemmi per far in
	 *	modo di reimpostare in automatico l'array una volta modificato. Essendo
	 *	questa classe un'estensione della classe Array, l'array stesso viene
	 *	a trovarsi nel puntatore this. Questo a comportato alcuni problemi in 
	 *	funzioni del tipo: this = c.concat();
	 *	Così, oltre all'introduzione di un array __clone usato per mantenere i dati
	 *	originale, sfruttando sempre questo ho dovuto creare una funzione clone()
	 *	che copia i dati in this.
	 *
	 * CHANGELOG
	 *	+ 1.1.0			Add shuffle() method ( thanks to http://jsfromhell.com/array/shuffle )
	 *	+ 1.0.0			First release
	 *
	 */
	 
	 public dynamic class MatrixArray extends Array {
		
		// _______________________________________________________________ STATIC
		
		static public const NAME			:String		= "MatrixArray";
		static public const VERSION			:String 	= "1.1.0";
		static public const AUTHOR			:String 	= "Giovambattista Fazioli <g.fazioli@undolog.com>";

		// ______________________________________ PROPERTIES INCAPSULATE VARIABLES
		
		private var __w						:uint;							// dimensione orizzontale della matrice
		private var __h						:uint;							// dimensione verticale della matrice
		private var __len					:uint;							// dimensione dell'array della matrice
		private var __clone					:Array;							// uso interno
		
		
		/**
		 * Costruttore
		 *
		 */	
		public function MatrixArray(w:uint, h:uint, ...args) {
			__w 	= w;
			__h 	= h;
			__len 	= w*h;
			if( args.length > 0 ) for( var i:uint = 0; i < args.length; i++) this[i] = args[i];
		}

		// ________________________________________________________________ PUBLIC METHODS 
		
		/**
		 * Mescola in modo casuale la matrice
		 *
		 */
		public function shuffle():void {
			// thanks to http://jsfromhell.com/array/shuffle
			for(var j, x, i = __len; i; j = Math.floor(Math.random() * __len), x = this[--i], this[i] = this[j], this[j] = x);
		}
		
		
		/**
		 * Restituisce una porzione (sx,sy,cw,ch) della matrice __w x __h
		 *
		 * @param	(uint)			sx Coordina x del taglio
		 * @param	(uint)			sy Coordina y del taglio
		 * @param	(uint)			cw Dimensione orizzontale del taglio
		 * @param	(uint)			ch Dimensione verticale del taglio
		 * @result	(MatrixArray)	Una nuova matrice cw x ch
		 *
		 */
		public function clip(sx:uint, sy:uint, cw:uint, ch:uint):MatrixArray {
			var r:MatrixArray = new MatrixArray(cw,ch);
			var ic:uint = 0, yc:uint = 0, xc:uint = 0;
			for(; yc < ch; yc++) {
				for(xc=0; xc < cw; xc++) {
					r[ic++] = this[ (sx+xc)+( (sy+yc)*__w ) ];
				}
			}
			return( r );		
		}
		
		/**
		 * Riempie la matrice con un determinato valore
		 *
		 * @param	(any)	Valore da inserire nella matrice
		 */
		public function fill(v:*):void { for(var i:uint=0; i < __len; i++) this[i] = v;	}
		
		/**
		 * Riempie l'array con un carattere prelevato da una stringa
		 * di lunghezza __w x __h
		 *
		 * @param	(string)	v Stringa con la serie di caratteri da mappare
		 * @result	(boolean)	true ok, false errore: stringa di lunghezza errata
		 *
		 */
		public function paintChar(v:String):Boolean {
			if( v.length == __len ) {
				var i:uint = 0;
				for(; i < __len; i++) this[i] = v.substr(i,1);
				return (true);
			}
			return(false);
		}
		
		/**
		 * Effettua un'operazione di Flip (riflessione) verticale 
		 * sulla matrice.
		 */
		public function flipH():void {
			__clone = [];
			var yy:uint	= 0;
			for(; yy < __h; yy++) __clone = __clone.concat( this.splice(0, __w).reverse() );
			this.clone();
		}
		
		/**
		 * Effettua un'operazione di Flip (riflessione) verticale 
		 * sulla matrice.
		 */
		public function flipV():void {
			__clone 	= [];
			var yy:uint	= 0;
			for(;yy<__h;yy++) __clone = __clone.concat( this.splice(-__w, __w) );
			this.clone();
		}		

		/**
		 * Sposta la matrice in una delle 4 direzioni possibili
		 *
		 * @param	(int)	ox Valore dello spostamento orizzontale
		 * @param	(int)	oy Valore dello spostamento verticale
		 */
		public function move(ox:int, oy:int):void {
			var yy:uint = 0, ic:uint = 0;
			__clone	= [];
			if(ox>0) for(ic=0; ic < ox; ic++) for(yy=0; yy < __h; yy++ ) this.splice( yy*__w, 0, this.splice( __w*(yy+1)-1, 1) ); 
			else if(ox<0) for(ic=0; ic < (-ox); ic++) for( yy=0; yy < __h; yy++ ) this.splice( __w*(yy+1)-1, 0, this.splice( yy*__w, 1) );
			if(oy>0) for(ic=0; ic < oy; ic++) { __clone = this.splice( -__w); __clone = __clone.concat(this); this.clone(); }
			else if(oy<0) for(ic=0; ic < (-oy); ic++) { __clone = this.splice( 0, __w); __clone = this.concat(__clone); this.clone(); }	
		}
		
		/**
		 * Restituisce il contenuto della matrice dai valore x,y
		 *
		 * @param	(uint)	xm Coordina x della matrice
		 * @param	(uint)	ym Coordina y della matrice
		 * @result	(any)	Contenuto
		 */
		public function peek(xm:uint,ym:uint):* {
			return( this[ (xm + (ym*__w)) ] )
		}
		
		/**
		 * Imposta il contenuto della matrice dai valore x,y
		 *
		 * @param	(uint)	xm Coordina x della matrice
		 * @param	(uint)	ym Coordina y della matrice
		 * @param	(any)	Contenuto
		 */
		public function poke(xm:uint,ym:uint, v:*):void {
			this[ (xm + (ym*__w)) ] = v;
		}
		
		/**
		 * Restistuisce l'array come una matrice testo __w x __h
		 *
		 * @result	(string)	La matrice come vista testuale
		 */
		public function getString():String {
			var ic:uint=0, yy:uint = 0, xx:uint = 0;
			var o:String = '';
			for(;yy<__h; yy++) {
				for(xx=0;xx<__w; xx++) {
					o += this[ic++];
				}
				o += '\n';
			}	
			return( o );
		}		
		
		// ________________________________________________________________ PRIVATE METHODS 
		
		/**
		 * Copia l'array di appoggio __clone in this
		 *
		 * @private
		 */
		private function clone():void {	var i:uint = 0; for(; i < __len; i++) this[i] = __clone[i]; }
		
	 }
}