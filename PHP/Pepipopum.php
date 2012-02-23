<?php
/**
 * Pepipopum - Automatic PO Translation via Google Translate
 * Copyright (C)2009  Paul Dixon (lordelph@gmail.com)
 * Copyright (C)2010  Juga Paazmaya (olavic@gmail.com)
 * $Id$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *
 * REQUIREMENTS:
 *
 * Requires curl to perform the Google Translate API call but could
 * easily be adapted to use something else or make the HTTP call
 * natively.
 */

/**
 * Passes untranslated entries through the Google Translate
 * API and writes the transformed PO to another file
 */
class Pepipopum
{
	public $debug = false;
	public $logfile = './pepipopum.debug.log';
	private $loghandle;
	
	public $languageIn = 'en';
	public $languageOut = 'fi';

    public $max_entries = 0; //for testing you can limit the number of entries processed
    private $start = 0; //timestamp when we started

	/**
	 * The translated PO data is build in this variable.
	 */
	private $translated = '';
	
    /**
     * Google API requires a referer - constructor will build a suitable default
     */
    public $referer;

    /**
	 * Define delay between Google API calls (can be fractional for sub-second delays).
     * How many seconds should we wait between Google API calls to be nice
     * to google and the server running Pepipopum? Can use a floating point
     * value for sub-second delays
     */
    public $delay = 0.25;

	/**
	 * curl resourse
	 */
	private $curl;

	/**
	 * Google Search API key
	 * http://code.google.com/apis/ajaxlanguage/documentation/reference.html#_intro_fonje
	 */
	public $apikey = 'ABQIAAAAyLIwOFKaznKcdf7DtmATHRS63tg4GPYAq5NgLkRBG-kstXlQIhR2bt33tcKswj6TjD_GOD3k-XKfcg';
	private $apiurl = 'http://ajax.googleapis.com/ajax/services/language/translate';

    public function __construct()
    {
        // Google API needs to be passed a referer
        $this->referer = 'http://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];

		$this->curl = curl_init();
		curl_setopt_array($this->curl, array(
			CURLOPT_HEADER => false,
			CURLOPT_REFERER => $this->referer,
			CURLOPT_RETURNTRANSFER => true
		));
    }


    /**
     * Translates a PO file storing output in desired location.
	 * Returns the translated PO as a string or false in case it failed.
     */
    public function translate($inData)
    {
		if ($this->debug && !$this->loghandle)
		{
			$this->loghandle = fopen($this->logfile, 'a');
			$this->trace('---- start -------------------');
			$this->trace('referer: ' . $this->referer);
		}
		
		$this->process($inData);
		
		if ($this->debug && $this->loghandle)
		{
			$this->trace('---- end ---------------------');
			fclose($this->loghandle);
		}
		return $this->translated;
    }
	
    /**
     * Parses input string and calls processEntry for each recgonized entry
     * and output for all other lines
     */
    public function process($inData)
    {
		$lines = explode("\n", $inData);
		
        set_time_limit(86400);
        $this->start = time();

        $msgid = $msgstr = array();
        $count = $state = 0;
		
		foreach($lines as $line)
		{
            $line = trim($line);
            $match_msgid = $match_msgstr = $match_empty = array();

			if ($this->debug)
			{
				$this->trace('line: '. $line);
				$this->trace('state: '. $state);
			}
			
			$found_msgid = preg_match('/^msgid(\s+)"(.*)"$/', $line, $match_msgid);
			$found_msgstr = preg_match('/^msgstr(\s+)"(.*)"$/', $line, $match_msgstr);
			$found_empty = preg_match('/"(.*)"/', $line, $match_empty);
			$found_hash = preg_match('/^#/', $line);
			
			if ($this->debug)
			{
				$this->trace('found_msgid: '. $found_msgid . ', found_msgstr: '. $found_msgstr . ', found_empty: '. $found_empty . ', found_hash: ' . $found_hash);
			}
			
			$found_msgid_pos = strpos($line, 'msgid');
			
            switch ($state)
            {
                case 0:
					//waiting for msgid
                    if ($found_msgid)
                    {
						if ($this->debug)
						{
							$this->trace('match_msgid: '. implode(', ', $match_msgid));
						}
                        $clean = stripcslashes($match_msgid[2]);
                        $msgid = array($clean);
                        $state = 1;
                    }
                    break;
                case 1: 
					//reading msgid, waiting for msgstr
                    if ($found_msgstr)
                    {
						if ($this->debug)
						{
							$this->trace('match_msgstr: '. implode(', ', $match_msgstr));
						}
                        $clean = stripcslashes($match_msgstr[2]);
                        $msgstr = array($clean);
                        $state = 2;
                    }
                    else if ($found_empty)
                    {
                        $msgid[] = stripcslashes($match_empty[1]);
                    }
                    break;
                case 2:
					//reading msgstr, waiting for blank
                    if ($found_empty)
                    {
                        $msgid[] = stripcslashes($match_empty[1]);
                    }
                    else if (empty($line) || $found_hash)
                    {
                        // We should have a complete entry
                        $this->processEntry($msgid, $msgstr); // this should add it to the output...
                        $count++;
						/*
                        if ($this->max_entries && ($count>$this->max_entries))
                        {
                            break 2;
                        }
						*/
                        $state = 0;
						$msgid = $msgstr = array();
                    }
                    break;
            }

			if ($this->debug)
			{
				$this->trace('count: ' . $count);
				$this->trace('msgid: ' . implode(', ', $msgid));
				$this->trace('msgstr: ' . implode(', ', $msgstr));
			}

            //comment or blank line?
            if (empty($line) || $found_hash)
            {
                $this->output($line . "\n");
            }
        }
		if ($this->debug)
		{
			$this->trace('Prosessing time: ' . (time() - $this->start) . ' sec');
		}
    }
	
    /**
     * Performs the Google Translate API call
	 * http://code.google.com/apis/ajaxlanguage/documentation/
     */
    protected function processEntry($msgid, $msgstr)
    {
        $input = implode('', $msgid);
        $output = implode('', $msgstr);

		if ($this->debug)
		{
			$this->trace('input: ' . $input);
			$this->trace('output: ' . $output);
		}
		
        if (!empty($input) && empty($output))
        {
            $q = urlencode($input);		
            $langpair = urlencode($this->languageIn . '|' . $this->languageOut);

			// http://code.google.com/apis/ajaxlanguage/documentation/reference.html#_intro_fonje
			$url = $this->apiurl . '?v=1.0&key=' . $this->apikey . '&hl=' . $this->languageIn . '&q=' . $q . '&langpair=' . $langpair;
			
			if ($this->debug)
			{
				$this->trace('url: ' . $url);
			}
			
			curl_setopt($this->curl, CURLOPT_URL, $url);
			$result = curl_exec($this->curl);

			if ($this->debug)
			{
				$this->trace('result: ' . $result);
			}
			/*
			{
			  "responseData" : {
				"translatedText" : the-translated-text,
				"detectedSourceLanguage"? : the-source-language
			  },
			  "responseDetails" : null | string-on-error,
			  "responseStatus" : 200 | error-code
			}
			*/

			if ($result !== false)
			{
				$data = json_decode($result);
				
				/*
				if ($this->debug)
				{
					echo '<pre>';
					print_r($data);
					echo '</pre>';
				}
				*/
				
				if (is_object($data) && is_object($data->responseData) && isset($data->responseData->translatedText))
				{
					$output = $data->responseData->translatedText;

					//Google translate mangles placeholders, lets restore them
					$output = preg_replace('/%\ss/', '%s', $output);
					$output = preg_replace('/% (\d+) \$ s/', ' %$1\$s', $output);
					$output = preg_replace('/^ %/', '%', $output);

					//have seen %1 get flipped to 1%
					if (preg_match('/%\d/', $input) && preg_match('/\d%/', $output))
					{
						$output = preg_replace('/(\d)%/', '%$1', $output);
					}

					//we also get entities for some chars
					$output = html_entity_decode($output, ENT_QUOTES, 'UTF-8');

					$msgstr = array($output);
				}
			}
			//play nice with google
			usleep($this->delay * 1000000);
        }
		
        //output entry
		$out = "msgid ";
        foreach($msgid as $part)
        {
            $part = addcslashes($part,"\r\n\"");
            $out .= "\"{$part}\"\n";
        }
        $out .= "msgstr ";
        foreach($msgstr as $part)
        {
            $part = addcslashes($part,"\r\n\"");
            $out .= "\"{$part}\"\n";
        }
        $this->output($out);
    }

    /**
     * Overriden output method writes to output file
     */
    protected function output($str)
    {
		$this->translated .= $str;
    }
	
	/**
	 * Debugging of the outgoing and incoming data.
	 */
	protected function trace($str)
	{
		//echo $str . "\n";
		// or write to the log file...
		if ($this->loghandle)
		{
			fwrite($this->loghandle, date('Y-m-d H:i:s') . "\t" . $str . "\n");
		}
	}
}
