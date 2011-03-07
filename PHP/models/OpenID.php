<?php

/**
 *
 */
class OpenID extends Zend_Db_Table
{

	/**
	 * Name of the database table.
	 */
    protected $_name = 'user_openid';


	/**
	 * select user_id from user_openid where openid_url = url
	 */
	public function getUserId($url)
	{
		$select = $this->select()
					->from($this, array('user_id'))
					->where('openid_url', $url);
        return $this->fetchRow($select);
	}

	/**
	 * select openid_url from user_openid where user_id = user
	 */
	public function getOpenIDsByUser($user)
	{
		$select = $this->select()
					->from($this, array('openid_url'))
					->where('user_id', $user);
        return $this->fetchAll($select);
	}

	/**
	 * insert into user_openid values (url, user)
	 */
	public function attachOpenID($url, $user)
	{
		$data = array(
			'openid_url' => $url,
			'user_id'    => $user,
			'modified'   => time()
		);
		$this->insert('user_openid', $data);
		return $this->lastInsertId();
	}

	/**
	 * delete from user_openid where openid_url = url and user_id = user
	 */
	public function detachOpenID($url, $user)
	{
		return $this->delete('user_openid', 'openid_url = '.$url);
	}

	/**
	 * delete from user_openid where user_id = user
	 */
	public function detachOpenIDsByUser($user)
	{
		return $this->delete('user_openid', 'user_id = '.$user);
	}
}
