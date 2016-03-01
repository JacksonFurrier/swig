%define INTERFACE_TYPEMAPS(CTYPE...)
%typemap(jtype) CTYPE, CTYPE *, CTYPE *const&, CTYPE [], CTYPE & "long"
%typemap(jstype) CTYPE "$&javainterfacename"
%typemap(jstype) CTYPE *, CTYPE [], CTYPE & "$javainterfacename"
%typemap(jstype) CTYPE *const& "$*javainterfacename"
%typemap(javain) CTYPE "$javainput.$&interfacename_GetInterfaceCPtr()"
%typemap(javain) CTYPE & "$javainput.$interfacename_GetInterfaceCPtr()"
%typemap(javain) CTYPE *, CTYPE [] "($javainput == null) ? 0 : $javainput.$interfacename_GetInterfaceCPtr()"
%typemap(javain) CTYPE *const& "($javainput == null) ? 0 : $javainput.$*interfacename_GetInterfaceCPtr()"
%typemap(javaout) CTYPE {
    return ($&javainterfacename)new $&javaclassname($jnicall, true);
  }
%typemap(javaout) CTYPE & {
    return ($javainterfacename)new $javaclassname($jnicall, $owner);
  }
%typemap(javaout) CTYPE *, CTYPE [] {
    long cPtr = $jnicall;
    return (cPtr == 0) ? null : ($javainterfacename)new $javaclassname(cPtr, $owner);
  }
%typemap(javaout) CTYPE *const& {
    long cPtr = $jnicall;
    return (cPtr == 0) ? null : ($javainterfacename)new $javaclassname(cPtr, $owner);
  }

%typemap(javadirectorin) CTYPE "($&javainterfacename)new $&javaclassname($jniinput, false)"
%typemap(javadirectorin) CTYPE & "($javainterfacename)new $javaclassname($jniinput, false)"
%typemap(javadirectorin) CTYPE *, CTYPE [] "($jniinput == 0) ? null : ($javainterfacename)new $javaclassname($jniinput, false)"
%typemap(javadirectorin) CTYPE *const& "($jniinput == 0) ? null : ($*javainterfacename)new $*javaclassname($jniinput, false)"
%typemap(javadirectorout) CTYPE "$javacall.$&interfacename_GetInterfaceCPtr()"
%typemap(javadirectorout) CTYPE *, CTYPE [], CTYPE & "$javacall.$interfacename_GetInterfaceCPtr()"
%typemap(javadirectorout) CTYPE *const& "$javacall.$*interfacename_GetInterfaceCPtr()"
%typemap(directorin,descriptor="L$packagepath/$&javainterfacename;") CTYPE
%{ $input = 0;
   *(($&1_ltype*)&$input) = &$1; %}
%typemap(directorin,descriptor="L$packagepath/$javainterfacename;") CTYPE *, CTYPE []
%{ *(($&1_ltype)&$input) = ($1_ltype) $1; %}
%typemap(directorin,descriptor="L$packagepath/$javainterfacename;") CTYPE &
%{ *($&1_ltype)&$input = ($1_ltype) &$1; %}
%typemap(directorin,descriptor="L$packagepath/$*javainterfacename;") CTYPE *const&
%{ *($&1_ltype)&$input = ($1_ltype) &$1; %}

%typemap(javainterfacecode, declaration="  long $interfacename_GetInterfaceCPtr();\n", cptrmethod="$interfacename_GetInterfaceCPtr") CTYPE %{
  public long $interfacename_GetInterfaceCPtr() {
    return $imclassname.$javaclazzname$interfacename_GetInterfaceCPtr(swigCPtr);
  }
%}
%enddef

%define %interface(CTYPE...)
%feature("interface", name="I%s") CTYPE;
INTERFACE_TYPEMAPS(CTYPE)
%enddef

%define %interface_impl(CTYPE...)
%rename("%sSwigImpl") CTYPE;
%feature("interface", name="%(regex:/(.*)SwigImpl$/\\1/)s") CTYPE;
INTERFACE_TYPEMAPS(CTYPE)
%enddef

%define %interface_custom(IMPL, INTERFACE, CTYPE...)
%rename(IMPL) CTYPE;
%feature("interface", name=INTERFACE) CTYPE;
INTERFACE_TYPEMAPS(CTYPE)
%enddef

