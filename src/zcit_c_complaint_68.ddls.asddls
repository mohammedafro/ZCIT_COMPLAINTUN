@EndUserText.label: 'Projection View for Complaint'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define root view entity ZCIT_C_COMPLAINT_68
  provider contract transactional_query
  as projection on ZCIT_I_COMPLAINT_68
{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Complaint ID'
  key ComplaintId,
  
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8  
      @EndUserText.label: 'Customer Name'
      CustomerName,
      
      @EndUserText.label: 'Email Address'
      CustomerEmail,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZCIT_I_COMP_CAT_VH_68', element: 'Category' } }]
      @EndUserText.label: 'Complaint Category'
      Category,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZCIT_I_COMP_PRIO_VH_68', element: 'Priority' } }]
      @EndUserText.label: 'Priority Level'
      Priority,
      
      PriorityCriticality,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZCIT_I_COMP_STAT_VH_68', element: 'Status' } }]
      @EndUserText.label: 'Current Status'
      Status,
      
      StatusCriticality,
      
      @EndUserText.label: 'Description of Issue'
      ComplaintDescription,
      
      @EndUserText.label: 'Resolution Progress (%)'
      ResolutionProgress,
      
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
