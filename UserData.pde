/**
 * Wrapper class to retrieve the user data connected to a box 2d collision as * one object
 */
public class UserData
{
    private Object _userData1;
    public Object getUserData1()
    {return _userData1;}

    private Object _userData2;
    public Object getUserData2()

    {return _userData2;}

    public UserData(Object userData1, Object userData2)
    {
        _userData1 = userData1;
        _userData2 = userData2;
    }
}