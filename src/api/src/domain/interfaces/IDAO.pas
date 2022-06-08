unit IDAO;

interface

uses
  Generics.Collections;

type
  iDAO<T: constructor> = interface
    ['{A454B5CE-6C67-432B-B5CB-49BBD3369D8E}']
    function Insert(var poObject: T): T; overload;
    function Insert(const poObject: TList<T>): TList<T>; overload;
    function Update(const poObject: T): T;
    function Delete(const poObject: T): T;
    function FindAll: TList<T>;
    function FindForID(const pnID: integer): T;
  end;

implementation

end.
