<?php
/*************************************************************************************************
eXist XML database library
Author:                  Eric Hanson <eric@aquameta.com>
                         http://www.aquameta.com/~eric/
Version:                 0.8
Date:                    February 28, 2005
Documentation:           See the README file.
*************************************************************************************************/

include_once ("inc/xmlrpc.inc");

class eXist {
	// connection
	var $path;
	var $hostname;
	var $port;
	
	// xmlrpc class
	var $client;
	
	// internal error
	var $error = "";
	
	// parameters
	var $param_indent;
	var $param_encoding;
	var $param_omit_xml_declaration;
	var $param_expand_xincludes;
	var $param_process_xsl_pi;
	var $param_highlight_matches;
	var $param_stylesheet;
		
			
	// constructor
	function eXist ($path, $hostname, $port=80) {
		$this->path = $path;
		$this->hostname = $hostname;
		$this->port = $port;
		
		$this->client = new xmlrpc_client ($path, $hostname, $port);
	}

	// username, password, defaults to blank -> guest
	function setCredentials ($username, $password) {
		$this->client->setCredentials ($username, $password);
	}

	// debug
	function setDebug ($bool) {
		$this->client->setDebug ($bool);
	}
	
	/////////////////////////////////////////////////////////////////////////////////////
	// XML-RPC methods
	// comments describe the XML-RPC API as implemented in Java by eXist.  Details
	// are available at http://exist-db.org/devguide.html#N105A6
	//
	// The PHP methods should mirror the Java API as closely as possible, though things
	// like byte arrays just get converted to Strings over XML-RPC, so we just stick
	// with that.
	/////////////////////////////////////////////////////////////////////////////////////
	
	// byte[] getDocument(String name, Hashtable parameters)
	function getDocument ($name) {
		$method = "getDocument";
		$_name = new xmlrpcval ($name,"string");
		$_parameters = $this->getParamsHash ();
		$args = array ($_name, $_parameters);
		$message = new xmlrpcmsg ($method,$args);
		return $this->sendMessage ($message);
	}
	
	// String getDocumentAsString(String name, Hashtable parameters)
	function getDocumentAsString ($name) {
		$method = "getDocumentAsString";
		$_name = new xmlrpcval ($name,"string");
		$_parameters = $this->getParamsHash ();
		$args = array ($_name, $_parameters);
		$message = new xmlrpcmsg ($method,$args);
		return $this->sendMessage ($message);
	}
	
	// Hashtable getDocumentData(String name, Hashtable parameters)
	function getDocumentData ($name) {
		$method = "getDocumentData";
		$_name = new xmlrpcval ($name, "string");
		$_parameters = $this->getParamsHash ();
		$args = array ($_name, $_parameters);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// Hashtable getNextChunk(String handle, int offset)
	function getNextChunk ($handle, $offset) {
		$method = "getNextChunk";
		$_handle = new xmlrpcval ($handle, "string");
		$_offset = new xmlrpcval ($offset, "int");
		$args = array ($_handle, $_offset);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// boolean parse(byte[] xml, String docName, int overwrite)
	// boolean parse(byte[] xml, String docName)
	function parse ($xml, $docName, $overwrite=0) {
		$method = "parse";
		$_xml = new xmlrpcval ($xml, "base64");
		$_docName = new xmlrpcval ($docName, "string");
		if ($overwrite > 0) {
			$_overwrite = new xmlrpcval ($overwrite, "int");
			$args = array ($_xml, $_docName, $_overwrite);
		}
		else {
			$args = array ($_xml, $_docName);
		}
		$message = new xmlrpcmsg ($method, $args);
		if ($this->sendMessage ($message)) return true;
		return false;
	}
	
	// String upload(byte[] chunk, int length)
	// String upload(String file, byte[] chunk, int length)
	// TODO: upload generates a filename with no . before the extension, for names like C:\Documents and Settings\Eric\Local Settings\Temp\rpc37222xml
	function upload ($a, $b, $c="UNDEF") {
		$method = "upload";
		// 3 params
		if ($c != "UNDEF") {
			$_file = new xmlrpcval ($a, "string");
			$_chunk = new xmlrpcval ($b, "base64");
			$_length = new xmlrpcval ($c, "int");
			$args = array ($_file, $_chunk, $_length);
		}
		// 2 params
		else {
			$_chunk = new xmlrpcval ($a, "base64");
			$_length = new xmlrpcval ($b, "int");
			$args = array ($_chunk, $_length);
		}
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// boolean parseLocal(String localFile, String docName, boolean replace)
	function parseLocal ($localFile, $docName, $replace) {
		$method = "parseLocal";
		$_localFile = new xmlrpcval ($localFile, "string");
		$_docName = new xmlrpcval ($docName, "string");
		$_replace = new xmlrpcval ($replace, "boolean");
		$args = array ($_localFile, $_docName, $_replace);
		$message = new xmlrpcmsg ($method, $args);
		if ($this->sendMessage ($message)) return true;
		return false;
	}
	
	// boolean createCollection(String name)
	function createCollection ($name) {
		$method = "createCollection";
		$_name = new xmlrpcval ($name, "string");
		$args = array ($_name);
		$message = new xmlrpcmsg ($method, $args);
		if ($this->sendMessage ($message)) return true;
		return false;		
	}
	
	// boolean remove(String docName)
	function remove ($docName) {
		$method = "remove";
		$_docName = new xmlrpcval ($docName, "string");
		$args = array ($_docName);
		$message = new xmlrpcmsg ($method, $args);
		if ($this->sendMessage ($message)) return true;
		return false;
	}
	
	// boolean removeCollection( String collection)
	function removeCollection ($collection) {
		$method = "removeCollection";
		$_collection = new xmlrpcval ($collection, "string");
		$args = array ($_collection);
		$message = new xmlrpcmsg ($method, $args);
		if ($this->sendMessage ($message)) return true;
		return false;
	}
	
	// int executeQuery(String xquery)
	// int executeQuery(byte[] xquery)
	// int executeQuery(byte[] xquery, String encoding)
	function executeQuery ($xquery, $encoding = false) {
		$method = "executeQuery";
		$_xquery = new xmlrpcval ($xquery, "base64");
		$_parameters = $this->getParamsHash ();

		// public int executeQuery(User user, byte[] xpath, String encoding, Hashtable parameters)
		if ($encoding) {
			$_encoding = new xmlrpcval ($encoding, "string");
			$args = array ($_xquery, $_encoding, $_parameters);
		} 
		
		// public int executeQuery(User user, String xpath, Hashtable parameters)
		else {
			$args = array ($_xquery, $_parameters);
		}
		
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// Hashtable querySummary(int resultId)
	function querySummary ($resultId) {
		$method = "querySummary";
		$_resultId = new xmlrpcval ($resultId, "int");
		$args = array ($_resultId);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// byte[] retrieve(int resultId, int pos, Hashtable parameters)
	function retrieve ($resultId, $pos) {
		$method = "retrieve";
		$_resultId = new xmlrpcval ($resultId, "int");
		$_pos = new xmlrpcval ($pos, "int");
		$_parameters = $this->getParamsHash ();
		$args = array ($_resultId, $_pos, $_parameters);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// int getHits(int resultId)
	function getHits ($resultId) {
		$method = "getHits";
		$_resultId = new xmlrpcval ($resultId, "int");
		$args = array ($_resultId);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// String query(byte[] xquery, int howmany, int start, Hashtable parameters)
	function query ($xquery, $howmany, $start) {
		$method = "query";
		$_xquery = new xmlrpcval ($xquery, "base64");
		$_howmany = new xmlrpcval ($howmany, "int");
		$_start = new xmlrpcval ($start, "int");
		$_parameters = $this->getParamsHash ();
		$args = array ($_xquery, $_howmany, $_start, $_parameters);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// void releaseQueryResult(int resultId)
	function releaseQueryResult ($resultId) {
		$method = "releaseQueryResults";
		$_resultId = new xmlrpcval ($resultId, "int");
		$args = array ($_resultId);
		$message = new xmlrpcmsg ($method, $args);
		return;
	}
	
	// Hashtable describeCollection(String collection)
	function describeCollection ($collection) {
		$method = "describeCollection";
		$_collection = new xmlrpcval ($collection, "string");
		$args = array ($_collection);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// Hashtable describeResource(String resource)
	function describeResource ($resource) {
		$method = "describeResource";
		$_resource = new xmlrpcval ($resource, "string");
		$args = array ($_resource);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// Hashtable getCollectionDesc(String collection)
	function getCollectionDesc ($collection) {
		$method = "getCollectionDesc";
		$_collection = new xmlrpcval ($collection, "string");
		$args = array ($_collection);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// int xupdate(String collectionName, byte[] xupdate)
	function xupdate ($collectionName, $xupdate) {
		$method = "xupdate";
		$_collectionName = new xmlrpcval ($collectionName, "string");
		$_xupdate = new xmlrpcval ($xupdate, "base64");
		$args = array ($_collectionName, $_xupdate);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// int xupdateResource(String documentName, byte[] xupdate)
	function xupdateResource ($documentName, $xupdate) {
		$method = "xupdateResource";
		$_documentName = new xmlrpcval ($documentName, "string");
		$_xupdate = new xmlrpcval ($xupdate, "base64");
		$args = array ($_documentName, $_xupdate);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// boolean setUser(String name, String passwd, Vector groups)
	// boolean setUser(String name, String passwd, Vector groups, String home)
	// TODO: For some reason it's creating a blank extra group
	function setUser ($name, $passwd, $groups, $home = false) {
		$method = "setUser";
		$_name = new xmlrpcval ($name, "string");
		$_password = new xmlrpcval (md5 ($password), "string");
		$_groups = new xmlrpcval ($groups, "array");
		if ($home != false) {
			$_home = new xmlrpcval ($home, "string");
			$args = array ($_name, $_password, $_groups, $_home);
		}
		else {
			$args = array ($_name, $_password, $_groups);
		}
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// boolean setPermissions(String resource, String permissions)
	// boolean setPermissions(String resource, int permissions)
	function setPermissions ($resource, $permissions) {
		$method = "setPermissions";
		$_resource = new xmlrpcval ($resource, "string");
		if (is_int ($permissions))
			$_permissions = new xmlrpcval ($permissions, "int");
		else
			$_permissions = new xmlrpcval ($permissions, "string");
		$args = array ($_resource, $_permissions);
		$message = new xmlrpcmsg ($method, $args);
		if ($this->sendMessage ($message)) return true;
		return false;
	}
	
	// boolean setPermissions(String resource, String owner, String ownerGroup, String permissions)
	// boolean setPermissions(String resource, String owner, String ownerGroup, int permissions)
	/*
	TODO: deal with identical method names with different signatures.
	function setPermissions ($resource, $owner, $ownerGroup, $permissions) {
		$method = "setPermissions";
		$_resource = new xmlrpcval ($resource, "string");
		$_owner = xmlrpcval ($owner, "string");
		$_ownerGroup = xmlrpcval ($ownerGroup, "string");
		if (is_int ($permissions))
			$_permissions = new xmlrpcval ($permissions, "int");
		else
			$_permissions = new xmlrpcval ($permissions, "string");
		$args = array ($_resource, $owner, $ownerGroup, $_permissions);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	*/
	
	// Hashtable getPermissions(String resource)
	function getPermissions ($resource) {
		$method = "getPermissions";
		$_resource = new xmlrpcval ($resource, "string");
		$args = array ($_resource);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// boolean removeUser(String name)
	// TODO: removeUser removes a user's home directory and all files in it, 
	// even if they're not owned by that user
	function removeUser ($name) {
		$method = "removeUser";
		$_name = new xmlrpcval ($name, "string");
		$args = array ($_name);
		$message = new xmlrpcmsg ($method, $args);
		if ($this->sendMessage ($message)) return true;
		return false;
	}
	
	// Hashtable getUser(String name)
	function getUser ($name) {
		$method = "getUser";
		$_name = new xmlrpcval ($name, "string");
		$args = array ($_name);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// Vector getUsers()
	function getUsers() {
		$method = "getUsers";
		$args = array ();
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// Vector getGroups()
	function getGroups() {
		$method = "getGroups";
		$args = array ();
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// Vector getIndexedElements(String collectionName, boolean inclusive)
	function getIndexedElements ($collectionName, $inclusive) {
		$method = "getIndexedElements";
		$_collectionName = new xmlrpcval ($collectionName, "string");
		$_inclusive = new xmlrpcval ($inclusive, "boolean");
		$args = array ($_collectionName, $_inclusive);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// Vector scanIndexTerms(String collectionName, String start, String end, boolean inclusive)
	function scanIndexTerms ($collectionName, $start, $end, $inclusive) {
		$method = "scanIndexTerms";
		$_collectionName = new xmlrpcval ($collectionName, "string");
		$_start = new xmlrpcval ($start, "string");
		$_end = new xmlrpcval ($end, "string");
		$_inclusive = new xmlrpcval ($inclusive, "boolean");
		$args = array ($_collectionName, $_start, $_end, $_inclusive);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
	}
	
	// boolean shutdown()
	function shutdown () {
		$method = "shutdown";
		$args = array ();
		$message = new xmlrpcmsg ($method, $args);
		if ($this->sendMessage ($message)) return true;
		return false;
	}
	
	// boolean sync()
	function sync () {
		$method = "sync";
		$args = array ();
		$message = new xmlrpcmsg ($method, $args);
		if ($this->sendMessage ($message)) return true;
		return false;
	}
	
	function getError () {
		return $this->error;
	}


	function dump () {
		?>
		<pre>
		path: <?=$this->path?>
		host: <?=$this->hostname?>
		port: <?=$this->port?>
		</pre>
		<?
	}
	
	//////////////////////////////////////////////////////////////////////////////////
	// parameter setting methods
	//////////////////////////////////////////////////////////////////////////////////
	
	function setParamIndent ($bool) {
		if ($bool) $this->param_indent = "yes";
		else $this->param_indent = "no";
	}
	
	function setParamEncoding ($encoding) {
		$this->param_encoding = $encoding;
	}
	
	function setParamOmitXmlDeclaration ($bool) {
		if ($bool) $this->param_omit_xml_declaration = "yes";
		else $this->param_omit_xml_declaration = "no";
	}
	
	function setParamExpandXIncludes ($bool) {
		if ($bool) $this->param_expand_xinclude = "yes";
		else $this->param_expand_xincludes = "no";
	}
	
	function setParamProcessXSLPI ($bool) {
		if ($bool) $this->param_process_xsl_pi = "yes";
		else $this->param_process_xsl_pi = "no";
	}
	
	function setParamHighlightMatches ($bool) {
		if ($bool) $this->param_highlight_matches = "yes";
		else $this->param_highlight_matches = "no";
	}
	
	function setParamStylesheet ($stylesheet) {
		$this->param_stylesheet = $stylesheet;
	}
	
	//////////////////////////////////////////////////////////////////////////////////
	// private methods
	//////////////////////////////////////////////////////////////////////////////////
	
	function sendMessage ($message) {
		$result = $this->client->send ($message);
	
		if(!$result) {
			$this->error = "Cannot send xmlrpc message to the server";
			return false;
		}
		
		if($result->faultCode()) {
			$this->error=$result->faultString();
			return false;
		}
		
		return xmlrpc_decode($result->value());
	}
	
	function getParamsHash () {
		$array = array ();
		// cant use dashes in variable names in PHP, so they're replaced with underscores.
		// but the xmlrpc variables have the dashes.
		if (isSet ($this->param_indent))               $array ['indent'] =               new xmlrpcval ($this->param_indent, "string");
		if (isSet ($this->param_encoding))             $array ['encoding'] =             new xmlrpcval ($this->param_encoding, "string");
		if (isSet ($this->param_omit_xml_declaration)) $array ['omit-xml-declaration'] = new xmlrpcval ($this->param_omit_xml_declaration, "string");
		if (isSet ($this->param_expand_xincludes))     $array ['expand-xincludes'] =     new xmlrpcval ($this->param_expand_xincludes, "string");
		if (isSet ($this->param_process_xsl_pi))       $array ['process-xsl-pi'] =       new xmlrpcval ($this->param_process_xsl_pi, "string");
		if (isSet ($this->param_highlight_matches))    $array ['highlight-matches'] =    new xmlrpcval ($this->param_highlight_matches, "string");
		if (isSet ($this->param_stylesheet))           $array ['stylesheet'] =           new xmlrpcval ($this->param_stylesheet, "string");
		// TODO if (isSet ($this->param_stylesheet-params.key1...))             $array ['encoding'] =             new xmlrpcval ($this->param_encoding);
		
		
		$hash = new xmlrpcval ($array, "struct");
		return $hash;
	}
}
?>
