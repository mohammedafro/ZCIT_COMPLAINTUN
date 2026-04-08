" 1. THE BUFFER: Temporarily holds data until SAP is ready to save
CLASS lcl_buffer DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA: mt_insert TYPE TABLE OF zcit_complaint,
                mt_update TYPE TABLE OF zcit_complaint,
                mt_delete TYPE TABLE OF zcit_complaint.
ENDCLASS.

" 2. THE HANDLER: Reads user input and puts it in the buffer
CLASS lhc_Complaint DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Complaint RESULT result.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Complaint.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Complaint.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Complaint.
    METHODS read FOR READ
      IMPORTING keys FOR READ Complaint RESULT result.
    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Complaint.
    METHODS resolveComplaint FOR MODIFY
      IMPORTING keys FOR ACTION Complaint~resolveComplaint RESULT result.
ENDCLASS.

CLASS lhc_Complaint IMPLEMENTATION.
  METHOD get_instance_authorizations. ENDMETHOD.

  METHOD create.
    LOOP AT entities INTO DATA(ls_entity).
      " Put new data into the INSERT buffer instead of the database
      APPEND VALUE #(
        complaint_id          = ls_entity-ComplaintId
        customer_name         = ls_entity-CustomerName
        customer_email        = ls_entity-CustomerEmail
        category              = ls_entity-Category
        priority              = ls_entity-Priority

        " FIXED: Now it reads your drop-down selection instead of forcing 'New'
        status                = ls_entity-Status

        complaint_description = ls_entity-ComplaintDescription

        " FIXED: Also reads progress from the UI, or defaults to 0
        resolution_progress   = ls_entity-ResolutionProgress
      ) TO lcl_buffer=>mt_insert.
    ENDLOOP.
  ENDMETHOD.
  METHOD update.
    LOOP AT entities INTO DATA(ls_entity).
      " Put changed data into the UPDATE buffer
      APPEND VALUE #(
        complaint_id          = ls_entity-ComplaintId
        customer_name         = ls_entity-CustomerName
        customer_email        = ls_entity-CustomerEmail
        category              = ls_entity-Category
        priority              = ls_entity-Priority
        status                = ls_entity-Status
        complaint_description = ls_entity-ComplaintDescription
        resolution_progress   = ls_entity-ResolutionProgress
      ) TO lcl_buffer=>mt_update.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys INTO DATA(ls_key).
      APPEND VALUE #( complaint_id = ls_key-ComplaintId ) TO lcl_buffer=>mt_delete.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    SELECT * FROM zcit_complaint FOR ALL ENTRIES IN @keys
      WHERE complaint_id = @keys-ComplaintId INTO TABLE @DATA(lt_complaint).

    result = CORRESPONDING #( lt_complaint MAPPING
      ComplaintId = complaint_id CustomerName = customer_name CustomerEmail = customer_email
      Category = category Priority = priority Status = status
      ComplaintDescription = complaint_description ResolutionProgress = resolution_progress ).
  ENDMETHOD.

  METHOD lock. ENDMETHOD.

  METHOD resolveComplaint.
    LOOP AT keys INTO DATA(ls_key).
      " Add to update buffer to change status to Resolved
      APPEND VALUE #( complaint_id = ls_key-ComplaintId status = 'Resolved' resolution_progress = 100 ) TO lcl_buffer=>mt_update.

      " Return result to UI
      INSERT VALUE #( ComplaintId = ls_key-ComplaintId
                      %param-ComplaintId = ls_key-ComplaintId
                      %param-Status = 'Resolved'
                      %param-ResolutionProgress = 100 ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

" 3. THE SAVER: SAP calls this automatically at the very end to write to the DB
CLASS lsc_ZCIT_I_COMPLAINT_68 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save REDEFINITION.
    METHODS cleanup REDEFINITION.
ENDCLASS.

CLASS lsc_ZCIT_I_COMPLAINT_68 IMPLEMENTATION.
  METHOD save.
    " Now we write everything in the buffers to the database safely!
    IF lcl_buffer=>mt_insert IS NOT INITIAL.
      INSERT zcit_complaint FROM TABLE @lcl_buffer=>mt_insert.
    ENDIF.
    IF lcl_buffer=>mt_update IS NOT INITIAL.
      UPDATE zcit_complaint FROM TABLE @lcl_buffer=>mt_update.
    ENDIF.
    IF lcl_buffer=>mt_delete IS NOT INITIAL.
      DELETE zcit_complaint FROM TABLE @lcl_buffer=>mt_delete.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    " Clear the buffers after saving
    CLEAR: lcl_buffer=>mt_insert, lcl_buffer=>mt_update, lcl_buffer=>mt_delete.
  ENDMETHOD.
ENDCLASS.
