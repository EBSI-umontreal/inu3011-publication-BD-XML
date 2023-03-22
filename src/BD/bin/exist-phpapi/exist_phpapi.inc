<?php
//http://llacan.vjf.cnrs.fr/moteur/crdomoteur/xml-rpc/test/xquery.phps


	include "bin/PHPXMLRPC3/xmlrpc.inc";


class eXist {
	var $path;
	var $hostname;
	var $port;
	
	var $client;
	
	var $error = "";
	
	var $param_indent;
	var $param_encoding;
	var $param_omit_xml_declaration;
	var $param_expand_xincludes;
	var $param_process_xsl_pi;
	var $param_highlight_matches;
	var $param_stylesheet;
		
			
	function eXist ($path, $hostname, $port=80, $method="http") {
		$this->path = $path;
		$this->hostname = $hostname;
		$this->port = $port;
		
		$this->client = new xmlrpc_client ($path, $hostname, $port, $method);
	}

	function setCredentials ($username, $password) {
		$this->client->setCredentials ($username, $password);
	}

	function setDebug ($bool) {
		$this->client->setDebug ($bool);
	}
	
	function getDocument ($name) {
		$method = "getDocument";
		$_name = new xmlrpcval($name,"string");
		$_parameters = $this->getParamsHash ();
		$args = array($_name, $_parameters);
		$message = new xmlrpcmsg($method,$args);
		return $this->sendMessage($message);
	}
	
	
	
	function sendMessage ($message) {
		$result = $this->client->send($message);
	
		if(!$result) {
			$this->error = "Cannot send xmlrpc message to the server";
			return false;
		}
		
		if($result->faultCode()) {
			$this->error=$result->faultString();
			return false;
		}
		
		return php_xmlrpc_decode($result->value());
	}
	
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
	
	function retrieve ($resultId, $pos) {
		$method = "retrieve";
		$_resultId = new xmlrpcval ($resultId, "int");
		$_pos = new xmlrpcval ($pos, "int");
		$_parameters = $this->getParamsHash ();
		$args = array ($_resultId, $_pos, $_parameters);
		$message = new xmlrpcmsg ($method, $args);
		return $this->sendMessage ($message);
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
