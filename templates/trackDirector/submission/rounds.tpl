{**
 * rounds.tpl
 *
 * Copyright (c) 2003-2005 The Public Knowledge Project
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate displaying past rounds for a submission.
 *
 * $Id$
 *}

<a name="rounds"></a>
<h3>{translate|escape key="trackDirector.regrets.regretsAndCancels"}</h3>

<table width="100%" class="listing">
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
	<tr valign="top">
		<td class="heading" width="30%">{translate key="user.name"}</td>
		<td class="heading" width="25%">{translate key="submission.request"}</td>
		<td class="heading" width="25%">{translate key="trackDirector.regrets.result"}</td>
		{if $schedConfSettings.reviewPapers}<td class="heading" width="20%">{translate key="submissions.reviewType"}</td>{/if}
	</tr>
	<tr><td colspan="4" class="headseparator">&nbsp;</td></tr>
{foreach from=$cancelsAndRegrets item=cancelOrRegret name=cancelsAndRegrets}
	<tr valign="top">
		<td>{$cancelOrRegret->getReviewerFullName()|escape}</td>
		<td>
			{if $cancelOrRegret->getDateNotified()}
				{$cancelOrRegret->getDateNotified()|date_format:$dateFormatTrunc}
			{else}
				&mdash;
			{/if}
		</td>
		<td>
			{if $cancelOrRegret->getDeclined()}
				{translate key="trackDirector.regrets"}
			{else}
				{translate key="common.cancelled"}
			{/if}
		</td>
		<td>{$cancelOrRegret->getRound()}</td>
	</tr>
	<tr>
		<td colspan="4" class="{if $smarty.foreach.cancelsAndRegrets.last}end{/if}separator">&nbsp;</td>
	</tr>
{foreachelse}
	<tr valign="top">
		<td colspan="4" class="nodata">{translate key="common.none}</td>
	</tr>
	<tr>
		<td colspan="4" class="endseparator">&nbsp;</td>
	</tr>
{/foreach}
</table>

{foreach from=$reviewAssignmentTypes item=reviewAssignments key=type}

{assign var=numRounds value=$reviewAssignments|@count}
{section name=round loop=$numRounds}
{assign var=round value=$smarty.section.round.index}
{assign var=roundPlusOne value=$round+1}
{assign var=roundAssignments value=$reviewAssignments[$roundPlusOne]}
{assign var=roundDecisions value=$directorDecisions[$type][$roundPlusOne]}
{assign var=needsTypeHeading value=1}

{if $submission->getReviewProgress() != $type || $submission->getCurrentRound() != $roundPlusOne}

{if $needsTypeHeading}
	<h3>{if $type == REVIEW_PROGRESS_ABSTRACT}{translate key="submission.abstractReview"}{else}{translate key="submission.paperReview"}{/if}</h3>
	{assign var=needsTypeHeading value=0}
{/if}

<h4>{translate key="trackDirector.regrets.reviewRound" round=$roundPlusOne}</h4>

{if $type != REVIEW_PROGRESS_ABSTRACT}
<table width="100%" class="data">
	<tr valign="top">
		<td class="label" width="20%">{translate key="submission.reviewVersion"}</td>
		<td class="value" width="80%">
			{assign var="reviewFile" value=$reviewFilesByRound[$roundPlusOne]}
			{if $reviewFile}
				<a href="{url op="downloadFile" path=$submission->getPaperId()|to_array:$reviewFile->getFileId():$reviewFile->getRevision()}" class="file">{$reviewFile->getFileName()|escape}</a>&nbsp;&nbsp;{$reviewFile->getDateModified()|date_format:$dateFormatShort}
			{else}
				{translate key="common.none"}
			{/if}
		</td>
	</tr>
</table>
{/if}

{assign var="start" value="A"|ord}

{foreach from=$roundAssignments item=reviewAssignment key=reviewKey}

{if !$reviewAssignment->getCancelled()}
<div class="separator"></div>
<h5>{translate key="user.role.reviewer"} {$reviewKey+$start|chr} {$reviewAssignment->getReviewerFullName()|escape}</h5>

<table width="100%" class="listing">
	<tr valign="top">
		<td width="20%">{translate key="reviewer.paper.schedule"}</td>
		<td width="20%" class="heading">{translate key="submission.request"}</td>
		<td width="20%" class="heading">{translate key="submission.underway"}</td>
		<td width="20%" class="heading">{translate key="submission.due"}</td>
		<td width="20%" class="heading">{translate key="submission.acknowledge"}</td>
	</tr>
	<tr valign="top">
		<td>&nbsp;</td>
		<td>
			{if $reviewAssignment->getDateNotified()}
				{$reviewAssignment->getDateNotified()|date_format:$dateFormatTrunc}
			{else}
				&mdash;
			{/if}
		</td>
		<td>
			{if $reviewAssignment->getDateConfirmed()}
				{$reviewAssignment->getDateConfirmed()|date_format:$dateFormatTrunc}
			{else}
				&mdash;
			{/if}
		</td>
		<td>
			{if $reviewAssignment->getDateDue()}
				{$reviewAssignment->getDateDue()|date_format:$dateFormatTrunc}
			{else}
				&mdash;
			{/if}
		</td>
		<td>
			{if $reviewAssignment->getDateAcknowledged()}
				{$reviewAssignment->getDateAcknowledged()|date_format:$dateFormatTrunc}
			{else}
				&mdash;
			{/if}
		</td>
	</tr>
	<tr valign="top">
		<td>{translate key="submission.recommendation"}</td>
		<td colspan="4">
			{if $reviewAssignment->getRecommendation()}
				{assign var="recommendation" value=$reviewAssignment->getRecommendation()}
				{translate key=$reviewerRecommendationOptions.$recommendation}
			{else}
				{translate key="common.none"}
			{/if}
		</td>
	</tr>
	<tr valign="top">
		<td class="label">{translate key="reviewer.paper.reviewerComments"}</td>
		<td colspan="4">
			{if $reviewAssignment->getMostRecentPeerReviewComment()}
				{assign var="comment" value=$reviewAssignment->getMostRecentPeerReviewComment()}
				<a href="javascript:openComments('{url op="viewPeerReviewComments" path=$submission->getPaperId()|to_array:$reviewAssignment->getReviewId() anchor=$comment->getCommentId()}');" class="icon">{icon name="comment"}</a> {$comment->getDatePosted()|date_format:$dateFormatShort}
			{else}
				<a href="javascript:openComments('{url op="viewPeerReviewComments" path=$submission->getPaperId()|to_array:$reviewAssignment->getReviewId()}');" class="icon">{icon name="comment"}</a>
			{/if}
		</td>
	</tr>
 	<tr valign="top">
		<td class="label">{translate key="reviewer.paper.uploadedFile"}</td>
		<td colspan="4">
			<table width="100%" class="data">
				{foreach from=$reviewAssignment->getReviewerFileRevisions() item=reviewerFile key=key}
				<tr valign="top">
					<td valign="middle">
						<form name="presenterView{$reviewAssignment->getReviewId()}" method="post" action="{url op="makeReviewerFileViewable"}">
							<a href="{url op="downloadFile" path=$submission->getPaperId()|to_array:$reviewerFile->getFileId():$reviewerFile->getRevision()}" class="file">{$reviewerFile->getFileName()|escape}</a>&nbsp;&nbsp;{$reviewerFile->getDateModified()|date_format:$dateFormatShort}
							<input type="hidden" name="reviewId" value="{$reviewAssignment->getReviewId()}" />
							<input type="hidden" name="paperId" value="{$submission->getPaperId()}" />
							<input type="hidden" name="fileId" value="{$reviewerFile->getFileId()}" />
							<input type="hidden" name="revision" value="{$reviewerFile->getRevision()}" />
							{translate key="director.paper.showPresenter"} <input type="checkbox"
name="viewable" value="1"{if $reviewerFile->getViewable()} checked="checked"{/if} />
							<input type="submit" value="{translate key="common.record"}" class="button" />
						</form>
					</td>
				</tr>
				{foreachelse}
				<tr valign="top">
					<td>{translate key="common.none"}</td>
				</tr>
				{/foreach}
			</table>
		</td>
	</tr>
</table>
{/if}
{/foreach}

<div class="separator"></div>

<h4>{translate key="trackDirector.regrets.decisionRound" round=$roundPlusOne}</h4>

{assign var=presenterFiles value=$submission->getPresenterFileRevisions($roundPlusOne)}
{assign var=directorFiles value=$submission->getDirectorFileRevisions($roundPlusOne)}

<table class="data" width="100%">
	<tr valign="top">
		<td class="label" width="20%">{translate key="director.paper.decision"}</td>
		<td class="value" width="80%">
			{foreach from=$roundDecisions item=directorDecision key=decisionKey}
				{if $decisionKey neq 0} | {/if}
				{assign var="decision" value=$directorDecision.decision}
				{translate key=$directorDecisionOptions.$decision} {$directorDecision.dateDecided|date_format:$dateFormatShort}
			{foreachelse}
				{translate key="common.none"}
			{/foreach}
		</td>
	</tr>
	<tr valign="top">
		<td class="label" width="20%">{translate key="submission.notifyPresenter"}</td>
		<td class="value" width="80%">
			{translate key="submission.directorPresenterRecord"}
			{if $submission->getMostRecentDirectorDecisionComment()}
				{assign var="comment" value=$submission->getMostRecentDirectorDecisionComment()}
				<a href="javascript:openComments('{url op="viewDirectorDecisionComments" path=$submission->getPaperId() anchor=$comment->getCommentId()}');" class="icon">{icon name="comment"}</a> {$comment->getDatePosted()|date_format:$dateFormatShort}
			{else}
				<a href="javascript:openComments('{url op="viewDirectorDecisionComments" path=$submission->getPaperId()}');" class="icon">{icon name="comment"}</a>
			{/if}
		</td>
	</tr>
	{foreach from=$presenterFiles item=presenterFile key=key}
		<tr valign="top">
			{if !$presenterRevisionExists}
				{assign var="presenterRevisionExists" value=true}
				<td width="20%" class="label" rowspan="{$presenterFiles|@count}" class="label">{translate key="submission.presenterVersion"}</td>
			{/if}
			<td width="80%" class="value"><a href="{url op="downloadFile" path=$submission->getPaperId()|to_array:$presenterFile->getFileId():$presenterFile->getRevision()}" class="file">{$presenterFile->getFileName()|escape}</a>&nbsp;&nbsp;{$presenterFile->getDateModified()|date_format:$dateFormatShort}</td>
		</tr>
	{foreachelse}
		<tr valign="top">
			<td width="20%" class="label">{translate key="submission.presenterVersion"}</td>
			<td width="80%" colspan="4" class="nodata">{translate key="common.none"}</td>
		</tr>
	{/foreach}
	{foreach from=$directorFiles item=directorFile key=key}
		<tr valign="top">
			{if !$directorRevisionExists}
				{assign var="directorRevisionExists" value=true}
				<td width="20%" class="label" rowspan="{$directorFiles|@count}" class="label">{translate key="submission.directorVersion"}</td>
			{/if}

			<td width="30%"><a href="{url op="downloadFile" path=$submission->getPaperId()|to_array:$directorFile->getFileId():$directorFile->getRevision()}" class="file">{$directorFile->getFileName()|escape}</a>&nbsp;&nbsp;{$directorFile->getDateModified()|date_format:$dateFormatShort}</td>
		</tr>
	{foreachelse}
		<tr valign="top">
			<td width="20%" class="label">{translate key="submission.directorVersion"}</td>
			<td width="80%" colspan="4" class="nodata">{translate key="common.none"}</td>
		</tr>
	{/foreach}
</table>

<div class="separator"></div>

{/if} {* End check to see that this is actually a past review, not the current one *}

{/section} {* End section to loop through all rounds *}

{/foreach} {* End foreach to loop through review types *}
