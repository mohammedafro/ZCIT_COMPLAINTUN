@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Complaint (Unmanaged)'

define root view entity ZCIT_I_COMPLAINT_68
  as select from zcit_complaint /* Pointing to your original table */
{
  key complaint_id          as ComplaintId,
      customer_name         as CustomerName,
      customer_email        as CustomerEmail,
      category              as Category,
      
      priority              as Priority,
      /* PREMIUM FEATURE: Priority Colors */
      case priority
        when 'High'   then 1
        when 'Medium' then 2
        when 'Low'    then 3
        else 0
      end                   as PriorityCriticality,

      status                as Status,
      /* PREMIUM FEATURE: Status Colors */
      case status
        when 'New'         then 1
        when 'In Progress' then 2
        when 'Resolved'    then 3
        else 0
      end                   as StatusCriticality,

      complaint_description as ComplaintDescription,
      resolution_progress   as ResolutionProgress,

      /* Administrative Fields */
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
}
