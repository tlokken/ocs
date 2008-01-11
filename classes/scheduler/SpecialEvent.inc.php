<?php

/**
 * @file SpecialEvent.inc.php
 *
 * Copyright (c) 2000-2007 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @package scheduler
 * @class SpecialEvent
 *
 * SpecialEvent class.
 * Basic class describing a specialEvent.
 *
 * $Id$
 */

class SpecialEvent extends DataObject {
	//
	// Get/set methods
	//

	/**
	 * Get the ID of the specialEvent.
	 * @return int
	 */
	function getSpecialEventId() {
		return $this->getData('specialEventId');
	}

	/**
	 * Set the ID of the specialEvent.
	 * @param $specialEventId int
	 */
	function setSpecialEventId($specialEventId) {
		return $this->setData('specialEventId', $specialEventId);
	}

	/**
	 * Get the sched conf ID of the specialEvent.
	 * @return int
	 */
	function getSchedConfId() {
		return $this->getData('schedConfId');
	}

	/**
	 * Set the sched conf ID of the specialEvent.
	 * @param $schedConfId int
	 */
	function setSchedConfId($schedConfId) {
		return $this->setData('schedConfId', $schedConfId);
	}

	/**
	 * Get the localized name of the specialEvent.
	 * @return string
	 */
	function getSpecialEventName() {
		return $this->getLocalizedData('name');
	}

	/**
	 * Get the name of the specialEvent.
	 * @param $locale string
	 * @return string
	 */
	function getName($locale) {
		return $this->getData('name', $locale);
	}

	/**
	 * Set the name of the specialEvent.
	 * @param $name string
	 * @param $locale string
	 */
	function setName($name, $locale) {
		return $this->setData('name', $name, $locale);
	}

	/**
	 * Get the localized description of the specialEvent.
	 * @return string
	 */
	function getSpecialEventDescription() {
		return $this->getLocalizedData('description');
	}

	/**
	 * Get the description of the room.
	 * @param $locale string
	 * @return string
	 */
	function getDescription($locale) {
		return $this->getData('description', $locale);
	}

	/**
	 * Set the description of the room.
	 * @param $description string
	 * @param $locale string
	 */
	function setDescription($description, $locale) {
		return $this->setData('description', $description, $locale);
	}

	/**
	 * Get whether or not the special event may occur multiple times.
	 * @return string
	 */
	function getIsMultiple() {
		return $this->getData('isMultiple');
	}

	/**
	 * Set whether or not the special event may occur multiple times.
	 * @param $isMultiple boolean
	 */
	function setIsMultiple($isMultiple) {
		return $this->setData('isMultiple', $isMultiple);
	}
}

?>