import GameplayKit


extension CGSize {
    public static func *(lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs);
    }
    
    public static func *=(lhs: inout CGSize, rhs: CGFloat) {
        lhs = CGSize(width: lhs.width * rhs, height: lhs.height * rhs);
    }
}
