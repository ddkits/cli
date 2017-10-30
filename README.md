#DDKits Platform

To ijnect admin in any template please use the 2 lines below at the top of your tempalate

@inject('isAdmin', 'App\Http\Controllers\AdminCont')
@if( $isAdmin->getAdmin() == 1 || Auth::user()->id == 1)

@endif
