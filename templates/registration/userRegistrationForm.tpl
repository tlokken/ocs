{**
 * userRegistrationForm.tpl
 *
 * Copyright (c) 2000-2007 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Attendee self-registration page.
 *
 * $Id$
 *}
{assign var="pageTitle" value="schedConf.registration"}
{include file="common/header.tpl"}

<form action="{url op="register"}" method="post">

{include file="common/formErrors.tpl"}

{assign var="registrationAdditionalInformation" value=$schedConf->getSetting('registrationAdditionalInformation')}
{if $registrationAdditionalInformation}
	<h3>{translate key="manager.registrationPolicies.registrationAdditionalInformation"}</h3>

	<p>{$registrationAdditionalInformation|nl2br}</p>

	<div class="separator"></div>
{/if}

<h3>{translate key="schedConf.registration.conferenceFees"}</h3>

{assign var="registrationMethodAvailable" value=0}

<table class="listing" width="100%">
	<tr>
		<td colspan="2" class="headseparator">&nbsp;</td>
	</tr>
	<tr valign="top" class="heading">
		<td width="60%">{translate key="schedConf.registration.type"}</td>
		<td width="60%">{translate key="schedConf.registration.cost"}</td>
	</tr>
	<tr>
		<td colspan="2" class="headseparator">&nbsp;</td>
	</tr>
	{assign var="isFirstRegistrationType" value=true}
	{iterate from=registrationTypes item=registrationType}
	{if $registrationType->getPublic()}
		<tr valign="top">
			<td class="label">
				<strong>{$registrationType->getTypeName()|escape}</strong>
			</td>
			<td class="data">
				{if strtotime($registrationType->getOpeningDate()) < time() && strtotime($registrationType->getClosingDate()) > time()}
					{assign var="registrationMethodAvailable" value=1}
					<input type="radio" name="registrationTypeId" {if $registrationTypeId == $registrationType->getTypeId() || (!$registrationTypeId && $isFirstRegistrationType)}checked="checked" {/if} value="{$registrationType->getTypeId()|escape}" />
					{$registrationType->getCost()|escape} {$registrationType->getCurrencyCodeAlpha()|escape}
					{translate key="schedConf.registration.typeCloses" closingDate=$registrationType->getClosingDate()|date_format:$dateFormatShort}
					{assign var="isFirstRegistrationType" value=false}
				{elseif strtotime($registrationType->getOpeningDate()) > time()}
					<input type="radio" name="registrationTypeId" value="{$registrationType->getTypeId()|escape}" disabled="disabled" />
					{$registrationType->getCost()|escape} {$registrationType->getCurrencyCodeAlpha()|escape}
					{translate key="schedConf.registration.typeFuture" openingDate=$registrationType->getOpeningDate()|date_format:$dateFormatShort}
				{else}
					<input type="radio" name="registrationTypeId" value="{$registrationType->getTypeId()|escape}" disabled="disabled" />
					{$registrationType->getCost()|escape} {$registrationType->getCurrencyCodeAlpha()|escape}
					{translate key="schedConf.registration.typeClosed" closingDate=$registrationType->getClosingDate()|date_format:$dateFormatShort}
				{/if}
			</td>
		</tr>
		{if $registrationType->getDescription()}
			<tr valign="top">
				<td colspan="2">{$registrationType->getDescription()|nl2br}</td>
			</tr>
		{/if}
		<tr valign="top">
			<td colspan="2">&nbsp;</td>
		</tr>
	{/if}
	{/iterate}
	{if $registrationTypes->wasEmpty()}
		<tr>
			<td colspan="2" class="nodata">{translate key="schedConf.registration.noneAvailable"}</td>
		</tr>
	{/if}
	<tr>
		<td colspan="2" class="endseparator">&nbsp;</td>
	</tr>
</table>

<p>
	<label for="feeCode">{translate key="schedConf.registration.feeCode"}</label>&nbsp;&nbsp;<input id="feeCode" name="feeCode" type="text" value="{$feeCode|escape}" class="textField" /><br />
	{translate key="schedConf.registration.feeCode.description"}
</p>

<div class="separator"></div>

{if !$registrationMethodAvailable}
	{assign var="disableSnippet" value="disabled=\"disabled\""}
{/if}

<h3>{translate key="schedConf.registration.account"}</h3>
{if $userLoggedIn}
	{url|assign:"logoutUrl" page="login" op="signOut" source=$requestUri}
	{url|assign:"profileUrl" page="user" op="profile"}
	<p>{translate key="schedConf.registration.loggedInAs" logoutUrl=$logoutUrl profileUrl=$profileUrl}</p>

	<table class="data" width="100%">
		<tr valign="top">
			<td width="20%" class="label">{translate key="user.name"}</td>
			<td width="80%" class="value">{$user->getFullName()|escape}</td>
		</tr>
		<tr valign="top">
			<td class="label">{translate key="user.email"}</td>
			<td class="value">{$user->getEmail()|escape}</td>
		</tr>
		<tr valign="top">
			<td class="label">{translate key="user.phone"}</td>
			<td class="value">{$user->getPhone()|escape}</td>
		</tr>
		<tr valign="top">
			<td class="label">{translate key="user.fax"}</td>
			<td class="value">{$user->getFax()|escape}</td>
		</tr>
		<tr valign="top">
			<td class="label">{translate key="common.mailingAddress"}</td>
			<td class="value">{$user->getMailingAddress()|strip_unsafe_html|nl2br}</td>
		</tr>
	</table>
{else}
	{url|assign:"loginUrl" page="login" op="index" source=$requestUri}
	<p>{translate key="schedConf.registration.createAccount.description" loginUrl=$loginUrl}</p>

	<table class="data" width="100%">
		<tr valign="top">	
			<td width="20%" class="label">{fieldLabel name="username" required="true" key="user.username"}</td>
			<td width="80%" class="value"><input {$disableSnippet} type="text" name="username" value="{$username|escape}" id="username" size="20" maxlength="32" class="textField" /></td>
	</tr>

	<tr valign="top">
		<td class="label">{fieldLabel name="password" required="true" key="user.password"}</td>
		<td class="value"><input {$disableSnippet} type="password" name="password" value="{$password|escape}" id="password" size="20" maxlength="32" class="textField" /></td>
	</tr>

	<tr valign="top">
		<td></td>
		<td class="instruct">{translate key="user.account.passwordLengthRestriction" length=$minPasswordLength}</td>
	</tr>
	<tr valign="top">
		<td class="label">{fieldLabel name="password2" required="true" key="user.account.repeatPassword"}</td>
		<td class="value"><input {$disableSnippet} type="password" name="password2" id="password2" value="{$password2|escape}" size="20" maxlength="32" class="textField" /></td>
	</tr>

{if $captchaEnabled}
		<tr>
			<td class="label" valign="top">{fieldLabel name="captcha" required="true" key="common.captchaField"}</td>
			<td class="value">
			<img src="{url page="user" op="viewCaptcha" path=$captchaId}" alt="" /><br />
			<span class="instruct">{translate key="common.captchaField.description"}</span><br />
			<input {$disableSnippet} name="captcha" id="captcha" value="" size="20" maxlength="32" class="textField" />
			<input type="hidden" name="captchaId" value="{$captchaId|escape:"quoted"}" />
		</td>
	</tr>
{/if}

<tr valign="top">
	<td class="label">{fieldLabel name="firstName" required="true" key="user.firstName"}</td>
	<td class="value"><input {$disableSnippet} type="text" id="firstName" name="firstName" value="{$firstName|escape}" size="20" maxlength="40" class="textField" /></td>
</tr>
	
<tr valign="top">
	<td class="label">{fieldLabel name="middleName" key="user.middleName"}</td>
	<td class="value"><input {$disableSnippet} type="text" id="middleName" name="middleName" value="{$middleName|escape}" size="20" maxlength="40" class="textField" /></td>
</tr>
	
<tr valign="top">
	<td class="label">{fieldLabel name="lastName" required="true" key="user.lastName"}</td>
	<td class="value"><input {$disableSnippet} type="text" id="lastName" name="lastName" value="{$lastName|escape}" size="20" maxlength="90" class="textField" /></td>
</tr>

<tr valign="top">
	<td class="label">{fieldLabel name="initials" key="user.initials"}</td>
	<td class="value"><input {$disableSnippet} type="text" id="initials" name="initials" value="{$initials|escape}" size="5" maxlength="5" class="textField" />&nbsp;&nbsp;{translate key="user.initialsExample"}</td>
</tr>
	
<tr valign="top">
	<td class="label">{fieldLabel name="affiliation" key="user.affiliation"}</td>
	<td class="value"><input {$disableSnippet} type="text" id="affiliation" name="affiliation" value="{$affiliation|escape}" size="30" maxlength="255" class="textField" /></td>
</tr>

<tr valign="top">
	<td class="label">{fieldLabel name="signature" key="user.signature"}</td>
	<td class="value"><textarea {$disableSnippet} name="signature" id="signature" rows="5" cols="40" class="textArea">{$signature|escape}</textarea></td>
</tr>

<tr valign="top">
	<td class="label">{fieldLabel name="email" required="true" key="user.email"}</td>
	<td class="value"><input {$disableSnippet} type="text" id="email" name="email" value="{$email|escape}" size="30" maxlength="90" class="textField" /></td>
</tr>

<tr valign="top">
	<td class="label">{fieldLabel name="userUrl" key="user.url"}</td>
	<td class="value"><input {$disableSnippet} type="text" id="userUrl" name="userUrl" value="{$userUrl|escape}" size="30" maxlength="90" class="textField" /></td>
</tr>
	
<tr valign="top">
	<td class="label">{fieldLabel name="phone" key="user.phone"}</td>
	<td class="value"><input {$disableSnippet} type="text" name="phone" id="phone" value="{$phone|escape}" size="15" maxlength="24" class="textField" /></td>
</tr>
	
<tr valign="top">
	<td class="label">{fieldLabel name="fax" key="user.fax"}</td>
	<td class="value"><input {$disableSnippet} type="text" name="fax" id="fax" value="{$fax|escape}" size="15" maxlength="24" class="textField" /></td>
</tr>
	
<tr valign="top">
	<td class="label">{fieldLabel name="mailingAddress" key="common.mailingAddress"}</td>
	<td class="value"><textarea {$disableSnippet} name="mailingAddress" id="mailingAddress" rows="3" cols="40" class="textArea">{$mailingAddress|escape}</textarea></td>
</tr>
	
<tr valign="top">
	<td class="label">{fieldLabel name="country" key="common.country"}</td>
	<td class="value">
		<select {$disableSnippet} name="country" id="country" class="selectMenu">
			<option value=""></option>
			{html_options options=$countries selected=$country}
		</select>
	</td>
</tr>

<tr valign="top">
	<td class="label">{fieldLabel name="biography" key="user.biography"}<br />{translate key="user.biography.description"}</td>
	<td class="value"><textarea {$disableSnippet} name="biography" id="biography" rows="5" cols="40" class="textArea">{$biography|escape}</textarea></td>
</tr>

{if $profileLocalesEnabled && count($availableLocales) > 1}
<tr valign="top">
	<td class="label">{translate key="user.workingLanguages"}</td>
	<td class="value">{foreach from=$availableLocales key=localeKey item=localeName}
		<input {$disableSnippet} type="checkbox" name="userLocales[]" id="userLocales-{$localeKey}" value="{$localeKey}"{if in_array($localeKey, $userLocales)} checked="checked"{/if} /> <label for="userLocales-{$localeKey}">{$localeName|escape}</label><br />
	{/foreach}</td>
</tr>

{/if}{* other locales exist *}

</table>

{/if}{* user is logged in *}

<div class="separator"></div>

<h3>{translate key="schedConf.registration.specialRequests"}</h3>

<p><label for="specialRequests">{translate key="schedConf.registration.specialRequests.description"}</label></p>

<p><textarea {$disableSnippet} name="specialRequests" id="specialRequests" cols="60" rows="10" class="textArea">{$specialRequests|escape}</textarea></p>

<div class="separator"></div>

{if $schedConfSettings.registrationName}
<h3>{translate key="manager.registrationPolicies.registrationContact"}</h3>

<table class="data" width="100%">
	<tr valign="top">
		<td width="20%" class="label">{translate key="user.name"}</td>
		<td width="80%" class="value">{$schedConfSettings.registrationName|escape}</td>
	</tr>
	{if $schedConfSettings.registrationEmail}<tr valign="top">
		<td class="label">{translate key="about.contact.email"}</td>
		<td class="value">{mailto address=$schedConfSettings.registrationEmail|escape encode="hex"}</td>
	</tr>{/if}
	{if $schedConfSettings.registrationPhone}<tr valign="top">
		<td class="label">{translate key="about.contact.phone"}</td>
		<td class="value">{$schedConfSettings.registrationPhone|escape}</td>
	</tr>{/if}
	{if $schedConfSettings.registrationFax}<tr valign="top">
		<td class="label">{translate key="about.contact.fax"}</td>
		<td class="value">{$schedConfSettings.registrationFax|escape}</td>
	</tr>{/if}
	{if $schedConfSettings.registrationMailingAddress}<tr valign="top">
		<td class="label">{translate key="common.mailingAddress"}</td>
		<td class="value">{$schedConfSettings.registrationMailingAddress|nl2br}</td>
	</tr>{/if}
</table>

<div class="separator"></div>
{/if}{* if displaying reg manager info *}

<p><input type="submit" value="{translate key="schedConf.registration.register"}" {if !$registrationMethodAvailable}disabled="disabled" class="button" {else}class="button defaultButton" {/if}/></p>

</form>

{include file="common/footer.tpl"}
